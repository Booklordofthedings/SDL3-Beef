namespace Setup;

using System;
using System.IO;
using System.Diagnostics;

using MiniZ;

class Program
{
	public static void Main()
	{
		if(AttemptToDownload() case .Ok)
			return;

	}

	public static Result<void> AttemptToDownload()
	{
		ProcessStartInfo info = scope .();
		info.UseShellExecute = false;
		info.SetFileNameAndArguments("curl -o sdl3.zip -L https://github.com/libsdl-org/SDL/releases/download/release-3.2.14/SDL3-devel-3.2.14-VC.zip");

		SpawnedProcess p = scope .();
		if(p.Start(info) case .Err)
			return .Err;

		while(!p.HasExited) {}

		if(p.ExitCode != 0)
			return .Err;

		if(!Directory.Exists("../dist"))
			if(Directory.CreateDirectory("../dist") case .Err)
				return .Err;

		MiniZ.ZipArchive archive = .();
		if(!MiniZ.ZipReaderInitFile(&archive, "sdl3.zip", .CompressedData))
			return .Err;

		for(int32 i  < (.)MiniZ.ZipReaderGetNumFiles(&archive))
		{
			MiniZ.ZipArchiveFileStat stats = .();
			if(!MiniZ.ZipReaderFileStat(&archive, i, &stats))
				continue;

			if(String.Compare(&stats.mFilename, "SDL3-3.2.14/lib/x64/SDL3.dll".Length, "SDL3-3.2.14/lib/x64/SDL3.dll", "SDL3-3.2.14/lib/x64/SDL3.dll".Length, false) == 0)
				MiniZ.ZipReaderExtractToFile(&archive, i, "../dist/SDL3.dll", .None);
			else if(String.Compare(&stats.mFilename, "SDL3-3.2.14/lib/x64/SDL3.lib".Length, "SDL3-3.2.14/lib/x64/SDL3.lib", "SDL3-3.2.14/lib/x64/SDL3.lib".Length, false) == 0)
				MiniZ.ZipReaderExtractToFile(&archive, i, "../dist/SDL3.lib", .None);
		}

		MiniZ.ZipReaderEnd(&archive);

		return .Ok;
	}
}