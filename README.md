# PowerShell CIDR

PowerShell CIDR functions is a collection of PowerShell scripts to help manipulate CIDR blocks. 
It is intended to be used with Deployment scripts to maximize the automation of creating virtual networks.

## Usage

```pwsh
. ./base.ps1

$x = Get-CidrSubnet -cidr "10.0.0.0/16" -extraBits 2 -count 2

```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

- I am currently learning about PowerShell scripting, so advice on testing frameworks would be great.

## License
[MIT](https://choosealicense.com/licenses/mit/)