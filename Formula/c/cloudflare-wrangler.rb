class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.68.0.tgz"
  sha256 "03d96ad26e98beea942233cfd882c758181ac6d2f0794deb85460753b2e5afe0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89c8509dd3c0c5438da1fe9bf4ff10cd4cc2b3723853411c8f521bc11cb0123c"
    sha256 cellar: :any,                 arm64_sequoia: "c50e63a008343810d9ca4302350acf8db241add343009233f8e5db6aafd44b30"
    sha256 cellar: :any,                 arm64_sonoma:  "c50e63a008343810d9ca4302350acf8db241add343009233f8e5db6aafd44b30"
    sha256 cellar: :any,                 sonoma:        "cf9162a2c0080a28ff4e159bc029962c36ebf18dffd2ddb618343eb85574f2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6976052b6b3535902ccc486d0edb1ad6aa35e809f28feb1825afe1716d0c29bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11aeba2eda894f671276872db9e05f6cacbcc447b0124e2ca8367603b5a73cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
