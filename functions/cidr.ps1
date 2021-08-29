function Get-CidrBlockInfo
{
    param([string]$cidr)

    $cidr -match '(\d+\.\d+\.\d+\.\d+)/(\d+)'

    $curIp = $Matches[1]
    $ipInfo = Get-IpInfo -ip $curIp
    $mask = [UInt32]$Matches[2]

    $maskNum = [UInt32] 0
    for($i = 0; $i -lt 32; $i++)
    {
        if ($i -lt $mask)
        {
            $maskNum = ($maskNum -shl 1) + 1
        }
        else
        {
            $maskNum = $maskNum -shl 1
        }
    }

    $numCidr = $ipInfo.IpNum

    $numCidrMin = $numCidr -band $maskNum
    $numCidrMax = $numCidrMin + (-bnot$maskNum)

    $minIp = Get-NumIpInfo -numIp $numCidrMin
    $maxIp = Get-NumIpInfo -numIp $numCidrMax
    $ipStr = $minIp.IpString
    $cidrStr = "${ipStr}/${mask}"

    return @{
        CidrBlock = $cidrStr;
        Mask = $mask;
        MinIp = $minIp;
        MaxIp = $maxIp;
    }
}