function PS2EXE {
    Param (
        [string]$content,
	[string]$outputFile
    )

    $script = [System.Convert]::ToBase64String(([System.Text.Encoding]::UTF8.GetBytes($content)))

    $translate = @"
using System;
using System.Management.Automation;
using System.Text;
using System.Reflection;
using System.Collections.ObjectModel;

namespace ModuleNamespace
{
    class Program
    {
        static void Main(string[] args)
        {
            string script = @"$script";
            PowerShell ps = PowerShell.Create();
            ps.AddScript(Encoding.UTF8.GetString(Convert.FromBase64String(script)));

            // Execute the script and capture the output
            Collection<PSObject> results = ps.Invoke();

            // Print each result to the console
            foreach (var result in results)
            {
                Console.WriteLine(result.ToString());
            }

            // If there are errors, print them as well
            if (ps.HadErrors)
            {
                foreach (var error in ps.Streams.Error)
                {
                    Console.WriteLine("Error: " + error.ToString());
                }
            }
        }
    }
}
"@

    $assemblyPath = ([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.ManifestModule.Name -ieq "System.Management.Automation.dll" } | Select-Object -First 1).Location

    $params = New-Object System.CodeDom.Compiler.CompilerParameters
    $params.GenerateExecutable = $true
    $params.OutputAssembly = $outputFile
    $params.CompilerOptions = "/platform:x64 /target:exe"
    $params.ReferencedAssemblies.Add("System.dll") > $null
    $params.ReferencedAssemblies.Add("System.Core.dll") > $null
    $params.ReferencedAssemblies.Add($assemblyPath) > $null

    $provider = New-Object Microsoft.CSharp.CSharpCodeProvider

    $results = $provider.CompileAssemblyFromSource($params, $translate)
}
