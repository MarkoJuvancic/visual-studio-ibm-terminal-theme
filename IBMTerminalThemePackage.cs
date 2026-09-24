using Microsoft.VisualStudio.Shell;
using System;
using System.Runtime.InteropServices;
using System.Threading;
using Task = System.Threading.Tasks.Task;

namespace IBMTerminalTheme
{
    [PackageRegistration(UseManagedResourcesOnly = true, AllowsBackgroundLoading = true)]
    [Guid(IBMTerminalThemePackage.PackageGuidString)]
    public sealed class IBMTerminalThemePackage : AsyncPackage
    {
        public const string PackageGuidString = "61080c4d-f361-44f7-b46a-664053ee95da";

        protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
        {
            await JoinableTaskFactory.SwitchToMainThreadAsync(cancellationToken);
        }
    }
}
