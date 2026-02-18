class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.3.0/jruby-dist-10.0.3.0-src.zip"
  sha256 "9209a9f0ed7d585e63e408e229cb629a3a18f04428373b8e8d9ed74c1e51abc2"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4783fa4522fff8ab6e18ce78a71fa442147f6978ee429eba8a9c59ad10f65295"
    sha256 cellar: :any,                 arm64_sequoia: "f5ce8335c6a3290e3c00494555cbf39b447804e6ff544572c7765449f235f445"
    sha256 cellar: :any,                 arm64_sonoma:  "f5ce8335c6a3290e3c00494555cbf39b447804e6ff544572c7765449f235f445"
    sha256 cellar: :any,                 sonoma:        "8437a84326e58721881f7c790687c9181f8d87f4b6f394d1bc8a270c90d5f405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac44cac0e6865a8f3c2e51bce0d0922d23a9277001ba046e876a1be927e547e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7f3b5501ef40ed646ad5ee00f0f2184765d2138fa3f483601b32de5aedc724"
  end

  depends_on "ant" => :build # for jffi
  depends_on "maven" => :build
  depends_on "pkgconf" => :build # for jffi
  depends_on "ruby" => :build # only used to detect conflicts

  depends_on "libfixposix" => :no_linkage
  depends_on "openjdk"

  uses_from_macos "libffi" # for jffi

  resource "jffi" do
    url "https://github.com/jnr/jffi/archive/refs/tags/jffi-1.3.14.tar.gz"
    sha256 "dfc120bc832cd81940fb785bef2987bd3f54199fddbed0e62145718d5a3d3b95"

    livecheck do
      url "https://raw.githubusercontent.com/jruby/jruby/refs/tags/#{LATEST_VERSION}/pom.xml"
      strategy :xml do |xml|
        xml.get_elements("//properties/jffi.version").map(&:text)
      end
    end
  end

  def install
    jffi_version = Version.new(File.read("pom.xml")[/<jffi\.version>([\d.]+)</i, 1])
    resource("jffi").stage do |r|
      odie "Need jffi version #{jffi_version}!" if r.version != jffi_version

      # Remove pre-built binaries and bundled libffi
      rm(Dir["archive/*"])
      rm_r("jni/libffi")
      ENV["LIBFFI_LIBS"] = if OS.mac?
        MacOS.sdk_for_formula(self).path/"usr/lib/libffi.tbd"
      else
        Formula["libffi"].opt_lib/shared_library("libffi")
      end

      # Avoid building universal binaries. Cannot use change_make_var! due to indentation
      inreplace "jni/GNUmakefile", "ARCHES = x86_64 arm64", "ARCHES = #{Hardware::CPU.arch}"

      system "ant", "-Duse.system.libffi=1", "jar"
      system "ant", "-Duse.system.libffi=1", "archive-platform-jar"
      system "mvn", "package"

      # Install JARs into local repository to be used by Maven when building JRuby
      system "mvn", "install:install-file", "-Dfile=target/jffi-#{r.version}.jar"
      system "mvn", "install:install-file", "-Dfile=target/jffi-#{r.version}-native.jar",
                                            "-DgroupId=com.github.jnr",
                                            "-DartifactId=jffi",
                                            "-Dpackaging=jar",
                                            "-Dversion=#{r.version}",
                                            "-Dclassifier=native"
    end

    system "mvn", "-Pdist"
    libexec.mkpath
    tarball = "maven/jruby-dist/target/jruby-dist-#{version}-bin.tar.gz"
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"

    # Make sure locally built copy was used by checking there is a single library
    jni_libs = libexec.glob("lib/jni/**/*jffi*").select(&:file?)
    odie "Expected single jffi library but found:\n  #{jni_libs.join("\n  ")}." unless jni_libs.one?

    # Remove Windows files and ffi-binary-libfixposix gem (pre-built libfixposix)
    rm libexec.glob("bin/*.{bat,dll,exe}")
    rm libexec/"lib/ruby/stdlib/libfixposix/binary.rb"
    rm_r libexec/"lib/ruby/stdlib/libfixposix/binary"

    # Expose commands on PATH but prefix a 'j' on any that conflict with Ruby
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    (bin.children(false) & Formula["ruby"].bin.children(false)).each do |cmd|
      if (bin/"j#{cmd}").exist?
        rm(bin/cmd)
      else
        bin.install bin/cmd => "j#{cmd}"
      end
    end
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e 'puts :hello'")

    ENV["GEM_HOME"] = testpath
    system bin/"jgem", "install", "json"
  end
end
