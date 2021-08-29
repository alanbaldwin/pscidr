#$baseCidr = "10.0.0.0/16"
#$takenCidrs = "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.5.0/24", "10.0.7.0/24"
#$takenCidrs = "10.0.0.0/8", "10.0.0.0/8"

function Get-AvailableCidr
{
    params([string] $baseCidr, [string] $takenCidrs, [Int32] $requestedSize)

    function Get-NextCidr
    {
        param([Int32] $num, [Int32] $mask)
        $curIp = Get-NumIpInfo -numIp $num
        $curIpStr = $curIp.IpString
        $cidrBlock = "${curIpStr}/${mask}"
        $nextRequiredCidrBlock = Get-CidrBlockInfo -cidr $cidrBlock
        return $nextRequiredCidrBlock
    }

    function IsCidrConflict
    {
        $cidr1 = $args[0]
        $cidr2 = $args[1]

        # cidr1.minIP is <= cidr1.maxIP - cidr1.maxIP < cidr2.minIP means
        # cidr1.minIP is < cidr2.minIP
        # similarly, cidr1.maxIp is >= cidr1.minIp, so cidr1.minIp > cidr2.MaxIp implies
        # cidr1.MaxIp > cidr2.MaxIp
        return -not(($cidr1.MaxIp.IpNum -lt $cidr2.MinIp.IpNum) -or ($cidr1.MinIp.IpNum -gt $cidr2.MaxIp.IpNum))
    }

    $baseCidrInfo = Get-CidrBlockInfo -cidr $baseCidr

    $firstIp = $baseCidrInfo.MinIp.IpNum

    $solvedCidrInfo = Get-NextCidr -num $firstIp -mask $requestedSize

    while ($solvedCidrInfo.MinIp.IpNum -le $baseCidrInfo.MaxIp.IpNum)
    {
        $conflict = false
        for($x = 0; $x -lt $takenCidrs.length; $x++) {
            $takenCidrInfo = Get-CidrBlockInfo $takenCidrs[$x]
            $conflict = IsCidrConflict $solvedCidrInfo $takenCidrInfo
            if ($conflict)
            {
                break;
            }
        }

        if (-not $conflict)
        {
            break;
        }

        $nextIp = ($solvedCidrInfo.MaxIp.IpNum + 1)
        $solvedCidrInfo = Get-NextCidr -num $nextIp -mask $requestedSize
    }

    if ($solvedCidrInfo.MinIp.IpNum -gt $baseCidrInfo.MaxIp.IpNum)
    {
        return false;
    }

    return $solvedCidrInfo
}