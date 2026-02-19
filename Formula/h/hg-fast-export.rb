class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/frej/fast-export.git", branch: "master"

  stable do
    url "https://github.com/frej/fast-export/archive/refs/tags/v250330.tar.gz"
    sha256 "1c4785f1e9e63e0ada87e0be5a7236d6889eea98975800671e3c3805b54bf801"

    # Backport fix for mercurial 7.2
    patch do
      url "https://github.com/frej/fast-export/commit/76db75d9631fc90a25f58afa39b72822e792e724.patch?full_index=1"
      sha256 "68c61af1c95ce55e9f41c18cbf6f7858139d6153654d343a639b30712350540b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26cbfd49c68c6f13eadcd0d6365eaa554aae4ea236b78780a87664f6795be7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e452579006d0079f87d4d472b2932ce585a2730058996782cf0b6054cd8e422e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa8a9b701199c436905cfa33617ac33bf918e08fbc6c820defdded2dd83c9e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "22d6c095c84ff4fdee418459f3aa0e9ceeef33de364dda42d24bd90232a7cf65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03cc5550a9adbe61efadcf56051885cc423d933ecf75bf43d74914090d9d4c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7799b942685a7fa60d59a8e9b77c2d8865a681c55ddcefa2d5b23c05fbb2360"
  end

  depends_on "mercurial"
  depends_on "python@3.14"

  def install
    python3 = which("python3.14")
    libexec.install "plugins", "pluginloader"
    bin.install buildpath.glob("hg*.{sh,py}")

    rewrite_shebang detected_python_shebang, *bin.children
    bin.env_script_all_files libexec/"bin", PYTHON: python3, PYTHONPATH: libexec
  end

  test do
    mkdir testpath/"hg-repo" do
      system "hg", "init"
      (testpath/"hg-repo/test.txt").write "Hello"
      system "hg", "add", "test.txt"
      system "hg", "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath/"git-repo" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system bin/"hg-fast-export.sh", "-r", testpath/"hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_path_exists testpath/"git-repo/test.txt"
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
