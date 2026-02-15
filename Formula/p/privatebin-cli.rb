class PrivatebinCli < Formula
  desc "CLI for creating and managing PrivateBin pastes"
  homepage "https://github.com/gearnode/privatebin"
  url "https://github.com/gearnode/privatebin/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "1b03499608fca426ad6ecc2ea1c33af3f13fd8eaea40b05adc26d7f25ca8c350"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "065645e665bd05cb5fa8308c363dcc5175c756b9f5423ecf2308536e80e7e71d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "065645e665bd05cb5fa8308c363dcc5175c756b9f5423ecf2308536e80e7e71d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065645e665bd05cb5fa8308c363dcc5175c756b9f5423ecf2308536e80e7e71d"
    sha256 cellar: :any_skip_relocation, sonoma:        "564bcaab2e4562084f74724662980b8486ac7bbc38f7a41554a38a56253742a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a409e6c36704248f474b4a2a8fcb6b8d791f6e82cdfae9de912f0b1f59a3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2416df5f2ae560e8fef1f8377534ce35d632232d29dcb74fe0d95e760e0049"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"privatebin"), "./cmd/privatebin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/privatebin --version")

    assert_match "Error: no privatebin instance configured", shell_output("#{bin}/privatebin create foo 2>&1", 1)
  end
end
