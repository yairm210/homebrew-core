class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/podman-container-tools/podman/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "3646384ab6eff7b3d4473e1a0c1e34b6a8001e5a89600af44cc12376da77bccc"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  compatibility_version 1
  head "https://github.com/podman-container-tools/podman.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created and upstream uses GitHub releases to
  # indicate when a version is released, so we check the "latest" release
  # instead of the Git tags. Maintainers confirmed:
  # https://github.com/Homebrew/homebrew-core/pull/205162#issuecomment-2607793814
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48cb1d34fa4fe9d7a2256236991b9d717a9d0b7565062a2b358b05ddda453ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e68c307125d8b22534e1e047ec2f5240e22938dc9a8b980df46db784446f4aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50774d2d6166eaf8890b1f318e1a1d390d8fe56d3837fd2653082e99bc7f826a"
    sha256                               arm64_linux:   "6dc639ac5dfb8dc74e51ae0b230cc6296b184b93fb60cd1bbf09aaff3022ffef"
    sha256                               x86_64_linux:  "e21c03e7c290ae8e90b33741f4ae1e9d336d2b45246c95a23a25af90a011fc55"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build
    depends_on arch: :arm64
    depends_on macos: :ventura # see discussions in https://github.com/containers/podman/issues/22121
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
    depends_on "protobuf" => :build
    depends_on "rust" => :build
    depends_on "conmon"
    depends_on "crun"
    depends_on "fuse-overlayfs"
    depends_on "gpgme"
    depends_on "libseccomp"
    depends_on "passt"
    depends_on "sqlite"
    depends_on "systemd"
  end

  # Bump these resources versions to match those in the corresponding version-tagged Makefile
  # at https://github.com/podman-container-tools/podman/blob/#{version}/contrib/pkginstaller/Makefile
  #
  # More context: https://github.com/Homebrew/homebrew-core/pull/205303
  resource "gvproxy" do
    livecheck do
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end

    on_macos do
      url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.9.tar.gz"
      sha256 "6cbcb7959a5d90b59253ea6d8bdf0285e2cfbc3b301398704b41e3069293f4fb"
    end
  end

  resource "vfkit" do
    livecheck do
      url :url
    end

    on_macos do
      url "https://github.com/crc-org/vfkit/archive/refs/tags/v0.6.4.tar.gz"
      sha256 "ff496bd6ee6772ed070f286c4282a8a2e2f5231d4f8e98b2255b883ba69af42d"
    end
  end

  resource "catatonit" do
    livecheck do
      url :url
    end

    on_linux do
      url "https://github.com/openSUSE/catatonit/archive/refs/tags/v0.2.1.tar.gz"
      sha256 "771385049516fdd561fbb9164eddf376075c4c7de3900a8b18654660172748f1"
    end
  end

  resource "netavark" do
    livecheck do
      url :url
    end

    on_linux do
      url "https://github.com/containers/netavark/archive/refs/tags/v2.1.0.tar.gz"
      sha256 "96677048168ddd1abe313e4c2e17f1cace72b60ee1bac8ca12a4bd7dfcadfbbb"
    end
  end

  resource "aardvark-dns" do
    livecheck do
      url :url
    end

    on_linux do
      url "https://github.com/containers/aardvark-dns/archive/refs/tags/v2.1.0.tar.gz"
      sha256 "daf871488603e659b0501224cf0731ac317809b1d1701fc061cb4f6ae39a894f"
    end
  end

  # Starting in podman 6.0.0, libkrun (via krunkit) is the default machine
  # driver on macOS. krunkit is not yet available in homebrew-core, so continue
  # using the previous default driver applehv.
  #
  # See https://github.com/Homebrew/homebrew-core/issues/291552
  # Remove once krunkit is available in homebrew-core.
  patch do
    file "Patches/podman/revert-libkrun-default.patch"
    type :unofficial
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"
      ENV["BUILD_ORIGIN"] = "brew"

      system "gmake", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
      end

      resource("vfkit").stage do
        ENV["CGO_ENABLED"] = "1"
        ENV["CGO_CFLAGS"] = "-mmacosx-version-min=11.0"
        ENV["GOOS"]="darwin"
        arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
        system "gmake", "out/vfkit-#{arch}"
        (libexec/"podman").install "out/vfkit-#{arch}" => "vfkit"
      end

      system "gmake", "podman-remote-darwin-docs"
      man1.install Dir["docs/build/remote/darwin/*.1"]

      bash_completion.install "completions/bash/podman"
      zsh_completion.install "completions/zsh/_podman"
      fish_completion.install "completions/fish/podman.fish"
    else
      paths = Dir["**/*.go"].select do |file|
        (buildpath/file).read.lines.grep(%r{/etc/containers/}).any?
      end
      inreplace paths, "/etc/containers/", etc/"containers/"

      ENV.O0
      ENV["PREFIX"] = prefix
      ENV["HELPER_BINARIES_DIR"] = opt_libexec/"podman"
      ENV["BUILD_ORIGIN"] = "brew"

      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arch == :arm64
        ENV["CGO_ENABLED"] = "1"
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie -trimpath"
      end

      system "make"
      system "make", "install", "install.completions"

      (prefix/"etc/containers/policy.json").write <<~JSON
        {"default":[{"type":"insecureAcceptAnything"}]}
      JSON

      (prefix/"etc/containers/storage.conf").write <<~CONF
        [storage]
        driver="overlay"
      CONF

      (prefix/"etc/containers/registries.conf").write <<~CONF
        unqualified-search-registries=["docker.io"]
      CONF

      resource("catatonit").stage do
        system "./autogen.sh"
        system "./configure"
        system "make"
        mv "catatonit", libexec/"podman/"
      end

      resource("netavark").stage do
        system "make"
        mv "bin/netavark", libexec/"podman/"
      end

      resource("aardvark-dns").stage do
        system "make"
        mv "bin/aardvark-dns", libexec/"podman/"
      end
    end
  end

  def caveats
    on_linux do
      <<~EOS
        You need "newuidmap" and "newgidmap" binaries installed system-wide
        for rootless containers to work properly.
      EOS
    end
    on_macos do
      <<~EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin/"podman", "system", "service", "--time", "0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    out = shell_output("#{bin}/podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      # This test will fail if VM images are not built yet. Re-run after VM images are built if this is the case
      # See https://github.com/Homebrew/homebrew-core/pull/166471
      out = shell_output("#{bin}/podman-remote machine init homebrew-testvm")
      assert_match "Machine init complete", out

      # Remove once krunkit is available and we follow the upstream behavior of using it
      # by default
      cfg_output = shell_output("#{bin}/podman-remote machine inspect homebrew-testvm --format {{.ConfigDir.Path}}")
      assert_equal (testpath/".config/containers/podman/machine/applehv").to_s, cfg_output.chomp

      system bin/"podman-remote", "machine", "rm", "-f", "homebrew-testvm"
    else
      assert_equal %w[podman podman-remote podmansh]
        .map { |binary| File.join(bin, binary) }.sort, Dir[bin/"*"]
      assert_equal %W[
        #{libexec}/podman/catatonit
        #{libexec}/podman/netavark
        #{libexec}/podman/aardvark-dns
        #{libexec}/podman/quadlet
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"]
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end
