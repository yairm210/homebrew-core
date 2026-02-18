class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.6.tar.gz"
  sha256 "4e351831875e81a2289d86299eec5dd681a778e0d96e6d2728e9efdd67887ee0"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98667343f1b702718719de12ee4e9292a80af30b6a6fabb12619e548b1bcf195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640c8f2d5ade17bceee20b875f46701795419c4e48b96ddeb988d0db4bdeec2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fbaa7ca8372c88d5f9e65f4f11e783a03e00c72477fa72fefd846b20ceef200"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc4ce8a988285cc3964776c1234fe6433ccecb3c50713701669dc964036a45ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e2f30d7e05f41a9e57a3eb88d60b63e9414ee7bf445d07a5c84a5ea7c5dc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f9096696dddc4a986b79b12e08509096f2e3c663e6321742aa6c5533f40b39"
  end

  depends_on "go" => :build

  # bump touchid-go to v0.3.0 for macos-14 compatibility, upstream pr ref, https://github.com/ByteNess/aws-vault/pull/300
  patch do
    url "https://github.com/ByteNess/aws-vault/commit/0dd90c6f9935ad84b528be78149e39b1bd683bd4.patch?full_index=1"
    sha256 "238f4f2cd029e8ac2dd418bca3999bd6f41575960a11089f2705059650449713"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version}-#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "."

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh" => "_aws-vault"
    bash_completion.install "contrib/completions/bash/aws-vault.bash" => "aws-vault"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: unable to select a 'profile', nor any AWS env vars found.",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
