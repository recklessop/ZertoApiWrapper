#Requires -Modules Pester
$moduleFileName = "ZertoApiWrapper.psd1"
$here = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace("Tests", "ZertoApiWrapper")
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$here\$sut"
$modulePath = $here -replace "Public", ""
$moduleFile = Get-ChildItem "$modulePath\$moduleFileName"
Get-Module -Name ZertoApiWrapper | Remove-Module -Force
Import-Module $moduleFile -Force

Describe $file.BaseName -Tag 'Unit' {
    Mock -ModuleName ZertoApiWrapper -CommandName Invoke-ZertoRestRequest {
        $null
    }
    Mock -ModuleName ZertoApiWrapper -CommandName Remove-Variable {

    }

    It "is valid Powershell (Has no script errors)" {
        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors | Should -HaveCount 0
    }

    Context "$($file.BaseName)::Parameter Unit Tests" {
        it "Does not take any parameters" {
            (get-command disconnect-zertoserver).parameters.count | Should -BeExactly 11
        }
    }

    Context "$($file.BaseName)::Function Unit Tests" {
        it "Does not return anything" {
            Disconnect-ZertoServer | Should -BeNullOrEmpty
        }
    }
}
