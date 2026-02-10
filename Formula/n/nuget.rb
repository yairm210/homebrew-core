class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v7.3.0/nuget.exe"
  sha256 "39b6309e76c832e4de2ac7f86da9a8afaa12bc5b4307ea335e9d69e2d6d1a94a"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    strategy :json do |json|
      json["nuget.exe"]&.map do |item|
        next if item["stage"] != "ReleasedAndBlessed"

        item["version"]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79c57b13732872ba19be0c33e04f3b5b8375d1baabfa2d7e06f7e703dcd123ee"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~BASH
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    BASH
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
