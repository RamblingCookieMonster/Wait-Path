Import-Module -Force $PSScriptRoot\..\Wait-Path.ps1

Describe 'Wait-Path' {
    
    Context 'Strict mode' { 

        Set-StrictMode -Version latest

        It 'Should succeed on known paths' {
            $StartTime = Get-Date
            $Output = Wait-Path -Path C:\, HKLM:\System, ENV:Path, Function:Wait-Path
            $EndTime = Get-Date

            #No output expected, default timeout is 5 seconds
            $Output | Should BeNullOrEmpty
            ($EndTime - $StartTime).TotalSeconds -le 5 | Should be $True
        }
        
        It 'Should error on timeout without passthru' {
            { Wait-Path -Timeout 1 -Path C:\WhoOnEarthWouldHaveThisPath } | Should Throw
        }

        It 'Should not error on timeout with passthru' {
            { Wait-Path -Timeout 1 -Path C:\WhoOnEarthWouldHaveThisPath -Passthru } | Should Not Throw
        }

        It 'Should return true when paths exist and passthru is used' {
            Wait-Path -Path C:\, HKLM:\System -Passthru | Should be $True
        }
        
        It "Should return false when paths don't exist or we time out and passthru is used" {
            Wait-Path -Timeout 1 -Path C:\WhoOnEarthWouldHaveThisPath -Passthru | Should be $False
        }
    }
}

