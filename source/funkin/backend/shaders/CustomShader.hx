package funkin.backend.shaders;

import haxe.Exception;
import openfl.Assets;
import funkin.backend.scripting.hscript.IHScriptCustomBehaviour;
import funkin.backend.shaders.FunkinShader;

class CustomShader extends FunkinShader {
	public var path:String = "";

	/**
	 * Creates a new custom shader
	 * @param name Name of the frag and vert files.
	 * @param glslVersion GLSL version to use. Defaults to `120`.
	 */
	public function new(name:String, glslVersion:String = "120") {
		var fragShaderPath = Paths.shaderFragment(name);
		var vertShaderPath = Paths.shaderVertex(name);
		var fragCode = Assets.exists(fragShaderPath) ? Assets.getText(fragShaderPath) : null;
		var vertCode = Assets.exists(vertShaderPath) ? Assets.getText(vertShaderPath) : null;

		fragFileName = fragShaderPath;
		vertFileName = vertShaderPath;

		path = fragShaderPath+vertShaderPath;

		if (fragCode == null && vertCode == null)
			Logs.traceNew('Shader "$name" couldn\'t be found.', ERROR);

		super(fragCode, vertCode, glslVersion);
	}
}