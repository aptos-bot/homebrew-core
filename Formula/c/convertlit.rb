class Convertlit < Formula
  desc "Convert Microsoft Reader format eBooks into open format"
  homepage "http://www.convertlit.com/"
  url "http://www.convertlit.com/clit18src.zip"
  version "1.8"
  sha256 "d70a85f5b945104340d56f48ec17bcf544e3bb3c35b1b3d58d230be699e557ba"
  license "GPL-2.0-or-later"

  # The archive filenames don't use periods in the version, so we have to match
  # the version from the link text.
  livecheck do
    url "http://www.convertlit.com/download.php"
    regex(/href=.*?clit[._-]?v?\d+(?:\.\d+)*src\.zip[^>]+>\s*?Convert LIT v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "16f86a985e46d742fb6e5ad4830e0d415611c75a523c90a5dc6de3669c0f179b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cc99de9129ef3228e3c8b9998bbd227846308b35c0de66e9103ed4defef29d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6f7298822916f88187c248ccf8c71b485eb397664fc3a84d84ca25f480de3b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487f8eae8213a6480a40b34b11acadb1e948090e3240ab557124c348e76a398c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef0e8a30545af331a8acbc7280dfaa41fab75a0bb87a2bf05b84e5ebdc8db2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2a095162cbd450903f4169677d360f3e1a2119342d2c2fa54ea4b85b46d7462"
    sha256 cellar: :any_skip_relocation, ventura:        "e5fca5a2bf373b68e302d6b9da7c475c516a33f9819448093af8b47cfdfec175"
    sha256 cellar: :any_skip_relocation, monterey:       "10c77d1b740056521f6cf689700ab021a1577722dc2d513dff560d91d811d789"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a70dcf4f3bc3b2806794651f1cbbf9effe317ea3d29b06339595bae0d6e71b9"
    sha256 cellar: :any_skip_relocation, catalina:       "72966d25e505751ac86204848a68cc6a9e3b1e0e57340f348a853bfeca72c2d3"
    sha256 cellar: :any_skip_relocation, mojave:         "7d06d34736082be89b9e6c0db2fa42c4d2b4fb15469bef2922003d3d299680c8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f41e31b1f6f53d1441bf670e75e0315f6a0f0e938de75e9973678ed565b6b4b8"
    sha256 cellar: :any_skip_relocation, sierra:         "43e28e7711f27843223b29d351ba0ce03a4deee76bbc99c4bdac50969b8eaeb7"
    sha256 cellar: :any_skip_relocation, el_capitan:     "66b05c2c6371f16620c82b31b507413556b511b859644322c65f4ceea4a83a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "983bf456c2fed65ab702faeb6ada0265c9cf32f72fbee7fcd967e81f68b49b2f"
  end

  depends_on "libtommath"

  def install
    # Workaround for Xcode 14.3
    %w[
      lib/Makefile
      clit18/Makefile
    ].each do |file|
      inreplace file do |s|
        if DevelopmentTools.clang_build_version >= 1403
          s.gsub! " -Wall ", " -Wall -Wno-implicit-function-declaration "
        end
      end
    end

    inreplace "clit18/Makefile" do |s|
      s.gsub! "-I ../libtommath-0.30", "#{HOMEBREW_PREFIX}/include"
      s.gsub! "../libtommath-0.30/libtommath.a", "#{HOMEBREW_PREFIX}/lib/libtommath.a"
    end

    system "make", "-C", "lib"
    system "make", "-C", "clit18"
    bin.install "clit18/clit"
  end

  test do
    (testpath/"test.lit").write("fake .lit file content")
    (testpath/"exploded").mkpath
    output = shell_output("#{bin}/clit test.lit #{testpath}/exploded 2>&1", 255)
    assert_match "LIT FORMAT ERROR: File is too small", output

    assert_match version.to_s, shell_output(bin/"clit", 255)
  end
end
