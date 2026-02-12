class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.12.1/source.tar.gz"
  sha256 "94b38e6031bad2409c176beae63580da35a1c3a1c129cc7c4c8f74f1e2965638"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eede5300ec3cc84e330a3c7bb45f625159dba01d104401b56533b5927b4dcad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ef6c6b4702d276f43ba782485383e2ddbb8760b92150ce7477919a9b536061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b21a86d3ca47ab0128856ea02a18d20c91bf5e013ae338b5b50c6068d9c45a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d41db01c3faaec7b2a3286ee18f3e06b60c073af58e0d767b88ed7203d9b2b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b387a2af9a95866572225bf5bfee9bb4ea1688d21545f02f9c9a095359b38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37038ac5513869289d7cc830294b3fb86f854605787f14d4e1c7edc92c9f2b91"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
