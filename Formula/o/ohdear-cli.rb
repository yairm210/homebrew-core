class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v5.0.0/ohdear.phar"
  sha256 "3a20dba5890edeebb09a62addf654fc41180bcea525fc8eb82802f01ea33870e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f610a110de9f9bf223b8107dd9bd718c53d20d97fcf1962ccd6cea4a972c1327"
  end

  depends_on "php"

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Your API token is invalid or expired.", shell_output("#{bin}/ohdear get-me", 1)
  end
end
