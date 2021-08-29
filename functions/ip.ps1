function Get-IpInfo
{
    param([string]$ip)

    $ip -match '(\d+)\.(\d+)\.(\d+)\.(\d+)'

    $ip1 = [UInt32]$Matches[1]
    $ip2 = [UInt32]$Matches[2]
    $ip3 = [UInt32]$Matches[3]
    $ip4 = [UInt32]$Matches[4]

    $numIp = [UInt32]($ip4 + ($ip3 -shl 8) + ($ip2 -shl 16) + ($ip1 -shl 24))

    $ipStr = Get-NumToIp -num $numIp
    return @{
        IpString = $ipStr;
        IpNum = $numIp;
    }
}

function Get-NumIpInfo
{
    param([UInt32]$numIp)

    $ipStr = Get-NumToIp -num $numIp
    return @{
        IpString = $ipStr;
        IpNum = $numIp;
    }
}

function Get-NumToIp
{
    param([UInt32] $num)
    $ipPart1 = [UInt32](($num -shr 24) -band 0x000000FF)
    $ipPart2 = [UInt32](($num -shr 16) -band 0x000000FF)
    $ipPart3 = [UInt32](($num -shr 8) -band 0x000000FF)
    $ipPart4 = [UInt32](($num -shr 0) -band 0x000000FF)
    return "${ipPart1}.${ipPart2}.${ipPart3}.${ipPart4}"
}