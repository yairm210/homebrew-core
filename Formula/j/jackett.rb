class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1109.tar.gz"
  sha256 "7cf598a98d25c77451eaa690e57ff7e3dde1e24fe622205d3f3101b37128e071"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b7f7563be92a32c10d2b022bc58551883046f58f1c84b35dd19e801a988ffc5"
    sha256 cellar: :any,                 arm64_sequoia: "b5ba2ba96c5852cea704f874e68b48063381a06e84568715186173f49ddef624"
    sha256 cellar: :any,                 arm64_sonoma:  "06107ebefb19ed03b7c46ccbbbb7319337896ee329eaea2496b5d73b67b8e4d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a32cb86308bf7a706b1c2d5a3a56d03be6987bf4df2ef745d724e66c0aa2cd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea49e9d754b9b5b6894d1720f7cd4cca0ac1d4507259ca1318772f73c28c557"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
