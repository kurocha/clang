
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "0.8.0"

define_target "clang" do |target|
	target.build do |environment|
		build_external(package.path, "clang-3.3", environment) do |config, fresh|
			FileUtils.mkdir("build")
			
			FileUtils.chdir("build") do
				Commands.run("cmake", "-G", "Unix Makefiles",
					"-DCMAKE_INSTALL_PREFIX:PATH=#{config.install_prefix}",
					"-DCMAKE_PREFIX_PATH=#{config.install_prefix}",
					"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
					"-DCMAKE_C_COMPILER_WORKS=TRUE",
					"-DBUILD_SHARED_LIBS=OFF",
					"-DCLANG_PATH_TO_LLVM_BUILD=#{config.install_prefix}",
					"-DCMAKE_BUILD_TYPE=#{config.variant}",
					"../"
				) if fresh
			
				Commands.make
				Commands.make_install
			end
		end
	end
	
	target.depends "Library/llvm-engine"
	target.provides "Library/clang"
end

define_configuration "local" do |configuration|
	configuration[:source] = "https://github.com/dream-framework/"
	
	configuration.import "clang"
end

define_configuration "clang" do |configuration|
	configuration.public!
	
	configuration.require "llvm"
end
