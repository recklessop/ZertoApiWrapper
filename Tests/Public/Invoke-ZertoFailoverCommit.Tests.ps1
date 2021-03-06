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

    It "is valid Powershell (Has no script errors)" {
        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors | Should -HaveCount 0
    }

    Context "$($file.BaseName)::Parameter Unit Tests" {

        it "Supports 'ShouldProcess'" {
            Get-Command $file.BaseName | Should -HaveParameter WhatIf
            Get-Command $file.BaseName | Should -HaveParameter Confirm
            $file | Should -FileContentMatch 'SupportsShouldProcess'
            $file | Should -FileContentMatch '\$PSCmdlet\.ShouldProcess\(.+\)'
        }

        it "has a mandatory string parameter for the vpgName" {
            Get-Command $file.BaseName | Should -HaveParameter vpgName
            Get-Command $file.BaseName | Should -HaveParameter vpgName -Type string[]
            Get-Command $file.BaseName | Should -HaveParameter vpgName -Mandatory
        }

        it "has a switch parameter for reverse protection" {
            Get-Command $file.BaseName | Should -HaveParameter reverseProtection
            Get-Command $file.BaseName | Should -HaveParameter reverseProtection -Type switch
        }
    }

    Context "$($file.BaseName)::Function Unit Tests" {
        #TODO
    }
}
