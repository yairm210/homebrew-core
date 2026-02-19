class Fracturedjson < Formula
  desc "JSON formatter that produces highly readable but fairly compact output"
  homepage "https://github.com/j-brooke/FracturedJson"
  url "https://github.com/j-brooke/FracturedJson/archive/refs/tags/cli-v1.0.0.tar.gz"
  sha256 "af9a33c1c054bf6cc363e57f07aacf4b712483346301862301da408e6e399d97"
  license "MIT"

  depends_on "dotnet" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os_tag = OS.mac? ? "osx" : "linux"
    args = %W[
      --configuration Release
      --runtime #{os_tag}-#{arch}
      --output #{libexec}
      --property InvariantGlobalization=true
    ]
    system "dotnet", "publish", "Cli/Cli.csproj", *args
    bin.install_symlink libexec/"fracjson"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fracjson --version")

    input_json = <<~JSON
      {"BasicObject":{"ModuleId":"armor","Locations":[[11,2],[11,3],[11,4],[11,5],[11,6],[11,7],[11,8],[11,9],[11,10],[11,11],[11,12],[11,13],
      [11,14],[1,14],[1,13],[1,12],[1,11],[1,10],[1,9],[1,8],[1,7],[1,6],[1,5],[1,4],[1,3],[1,2],[4,2],[5,2],[6,2],[7,2]],"Seed":272691529},
      "SimilarArrays":{"Katherine":["blue","lightblue","black"],"Logan":["yellow","blue","black","red"],"Erik":["red","purple"]}}
    JSON
    output = pipe_output("#{bin}/fracjson", input_json, 0).chomp
    assert_operator output.lines.count, :>, 3
  end
end
