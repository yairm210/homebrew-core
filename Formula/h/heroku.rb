class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.17.0.tgz"
  sha256 "a443d816a7d52aa58751c7a1a95406a83a58d88860e554b2b3d796e08e5a4ccf"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "219c50c16fd63828d3798e372351d87d5a990755e465da421c1521f55a600d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b272df800332d73c996233621e9751a86d0637289415988d989b3157321de76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b272df800332d73c996233621e9751a86d0637289415988d989b3157321de76f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a8883a497b55c93494d05c9dd9daec4efa36dfe3e895d719c1471bb4446082b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f0cc5884b5bbc1a4f3947f3165e0448761947833bed758abdb3f82d384c427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f0cc5884b5bbc1a4f3947f3165e0448761947833bed758abdb3f82d384c427"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
