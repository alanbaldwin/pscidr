function Get-CidrSubnet {
    param([string] $cidr, [Int32] $extraBits, [Int32] $count)

    $cidrInfo = Get-CidrBlockInfo -cidr $cidr
    $minIpNum = $cidrInfo.MinIp.IpNum
    $requestedMask = $cidrInfo.Mask + $extraBits

    $requestedNum = $minIpNum + ($count -shl (32 - $requestedMask))
    $requestedIp = Get-NumIpInfo -numIp $requestedNum
    $requestedIpString = $requestedIp.IpString
    $requestedCidr = "${requestedIpString}/${requestedMask}"
    $requestedCidrInfo = Get-CidrBlockInfo -cidr $requestedCidr
    return $requestedCidrInfo
}