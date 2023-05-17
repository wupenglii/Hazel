workspace "Hazel"
	architecture "x86_64"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Hazel"
	location "Hazel"
	kind "SharedLib"
	language "c++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include"
	}

	filter "system:windows"
		cppdialect "c++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "HZ_BUILD_DLL",
            "HZ_PLATFORM_WINDOWS"
        }

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "On"
		
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		symbols "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		symbols "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "c++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Hazel/vendor/spdlog/include",
		"Hazel/src"
	}

	links
	{
		"Hazel"
	}

	filter "system:windows"
		cppdialect "c++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "HZ_PLATFORM_WINDOWS"
        }

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "On"
		
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		symbols "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		symbols "On"