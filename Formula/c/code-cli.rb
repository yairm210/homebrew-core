class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.109.1.tar.gz"
  sha256 "fd473ee592b541f4f953e9accb42e71368ca1853bd965ba98a94c3f94e11a7c3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "aea7c3fea76bb10c67571858a61db6c8797ba0ce2fe487a2cf22111b8663136a"
    sha256 cellar: :any,                 arm64_sequoia: "60b1e8e96069cd7af2e7141bcef77edc71ca081c9c97d57377610e7074bc1635"
    sha256 cellar: :any,                 arm64_sonoma:  "516dfb2d826c3b259f3f94b6a9571a4fd05cab51d4aa563e17aa82baa4a5e4f2"
    sha256 cellar: :any,                 sonoma:        "3c439e02f5c2eed923a6714ea39d4ca545b9b153a7ca19a52d1e361820f2e208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3521fa0f082f6156c6cca5bdb4df146ba5ff1216bf1ca6fb2a6b08c85f7397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d167b078408009690fdd03bba6187c1730c1ccbd30262eadb1982cbe07b7bf89"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
