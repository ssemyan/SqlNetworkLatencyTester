$ErrorActionPreference = "Stop"

$resourceGroupName = wktest

$filename = "runlog_$(get-date -f HH_mm_ss).txt"

Write-Host writing to $filename
'Starting run' | Tee -FilePath $filename

$dbsizes =
@(
#[pscustomobject]@{edition="Basic"},
#[pscustomobject]@{edition="Standard";rso="S0"},
#[pscustomobject]@{edition="Standard";rso="S2"},
[pscustomobject]@{edition="Premium";rso="P1"},
#[pscustomobject]@{edition="GeneralPurpose";ComputeGeneration="Gen4";vcore="2"},
[pscustomobject]@{edition="GeneralPurpose";ComputeGeneration="Gen4";vcore="4"},
#[pscustomobject]@{edition="GeneralPurpose";ComputeGeneration="Gen5";vcore="2"},
[pscustomobject]@{edition="GeneralPurpose";ComputeGeneration="Gen5";vcore="4"},
#[pscustomobject]@{edition="BusinessCritical";ComputeGeneration="Gen4";vcore="2"},
[pscustomobject]@{edition="BusinessCritical";ComputeGeneration="Gen4";vcore="4"},
#[pscustomobject]@{edition="BusinessCritical";ComputeGeneration="Gen5";vcore="2"},
[pscustomobject]@{edition="BusinessCritical";ComputeGeneration="Gen5";vcore="4"})

foreach ($size in $dbsizes)
{
    Get-Date | Tee -FilePath $filename -Append 

    "Setting DB to $($size.edition) $($size.rso) $($size.ComputeGeneration) $($size.vcore)" | Tee -FilePath $filename -Append 
    
    if ($size.ComputeGeneration -ne $null)
    {
        $database = Set-AzSqlDatabase -ResourceGroupName $resourceGroupName `
            -ServerName scottsewktest -DatabaseName wktestdb `
            -Edition $size.edition -ComputeGeneration $size.ComputeGeneration -VCore $size.vcore
    } elseif ($size.rso -ne $null)
    {
        $database = Set-AzSqlDatabase -ResourceGroupName $resourceGroupName `
            -ServerName scottsewktest -DatabaseName wktestdb `
            -Edition $size.edition -RequestedServiceObjectiveName $size.rso
    } else 
    {
            $database = Set-AzSqlDatabase -ResourceGroupName $resourceGroupName `
            -ServerName scottsewktest -DatabaseName wktestdb `
            -Edition $size.edition 
    }

    $database | Tee -FilePath $filename -Append 

    for ($i = 1; $i -lt 5; $i++)
    {
        "Sleeping 10 seconds..." | Tee -FilePath $filename -Append 
        sleep -Seconds 10

        "Running perf test $i" | Tee -FilePath $filename -Append 

        $didtest = $false

        while ($didtest -eq $false)
        {
            try
            {
                .\sqltest.exe | Tee -FilePath $filename -Append 
                if ($LASTEXITCODE -ne 0)
                {
                    throw "Error"
                }
                $didtest = $true

            } catch {
                Write-Host Error running - trying again after 10 sec | Tee -FilePath $filename -Append 
                sleep -Seconds 10
            }
        }

    }
}