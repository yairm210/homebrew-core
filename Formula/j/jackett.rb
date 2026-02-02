class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1012.tar.gz"
  sha256 "d1044f1364fe3c8b82a93043b33c0e746b6e460cb0b8af0ec0f190fceaec68e4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "322a5f9accfb4a0ff6d61c119f7e65f18c8110ef4525b82bfee924b01421a002"
    sha256 cellar: :any,                 arm64_sequoia: "0814ef9a9bcb858556b0cdc383387cfe998d369e40c0b7e92f76ef35af0f35b5"
    sha256 cellar: :any,                 arm64_sonoma:  "049d39ded8e2692f179fe3bca96bcc27dbe09c2ff373910c5e41d21029a9c594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c530cd320462b66e8f5e0ab8b9d0ead63e40ec061150d0c2fcc0b15546ecb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "897528132539becf2ff0aa90eaf9a082618f4b943bfc59d94e1a68fc9e4063cb"
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
