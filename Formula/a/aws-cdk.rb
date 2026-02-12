class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1106.0.tgz"
  sha256 "c4c55bcdbb6d11d46f78dbb3d33492324de8add3f700fc17a37caf7538a399ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d21d4396712ab046123c9c064b465bea549ebed0c20f9a63125427945e0d04b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
