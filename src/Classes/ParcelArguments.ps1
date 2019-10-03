class ParcelArguments
{
    [string] $Install
    [string] $Uninstall

    ParcelArguments([object]$_args)
    {
        if ($_args -is [string]) {
            $this.Install = $_args
            $this.Uninstall = $_args
        }
        else {
            $this.Install = $_args.install
            $this.Uninstall = $_args.uninstall
        }
    }
}