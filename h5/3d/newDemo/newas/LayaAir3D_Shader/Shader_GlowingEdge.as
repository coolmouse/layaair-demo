package shaderModule {
	import common.CameraMoveScript;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.PrimitiveMesh;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.SubShader;
	import laya.display.Stage;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.Texture2D;
	import shaderModule.customMaterials.CustomMaterial;
	
	/**
	 * ...
	 * @author
	 */
	public class Shader_GlowingEdge {
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		
		public function Shader_GlowingEdge() {
			Shader3D.debugMode = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			initShader();
			
			var scene:Scene3D = Laya.stage.addChild(new Scene3D()) as Scene3D;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
			camera.transform.translate(new Vector3(0, 0.85, 1.7));
			camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.color = new Vector3(1, 1, 1);
			
			Sprite3D.load("res/threeDimen/skinModel/dude/dude.lh", Handler.create(null, function(dude:Sprite3D):void {
				scene.addChild(dude);
				
				var customMaterial1:CustomMaterial = new CustomMaterial();
				Texture2D.load("res/threeDimen/skinModel/dude/Assets/dude/head.png", Handler.create(null, function(tex:Texture2D):void {
					customMaterial1.diffuseTexture = tex;
				}));
				customMaterial1.marginalColor = new Vector3(1, 0.7, 0);
				
				var customMaterial2:CustomMaterial = new CustomMaterial();
				Texture2D.load("res/threeDimen/skinModel/dude/Assets/dude/jacket.png", Handler.create(null, function(tex:Texture2D):void {
					customMaterial2.diffuseTexture = tex;
				}));
				customMaterial2.marginalColor = new Vector3(1, 0.7, 0);
				
				var customMaterial3:CustomMaterial = new CustomMaterial();
				Texture2D.load("res/threeDimen/skinModel/dude/Assets/dude/pants.png",Handler.create(null,function(tex:Texture2D):void{
					customMaterial3.diffuseTexture = tex;
				}));
				customMaterial3.marginalColor = new Vector3(1, 0.7, 0);
				
				var customMaterial4:CustomMaterial = new CustomMaterial();
				Texture2D.load("res/threeDimen/skinModel/dude/Assets/dude/upBodyC.png",Handler.create(null,function(tex:Texture2D):void{
					customMaterial4.diffuseTexture =tex ;
				}))
				customMaterial4.marginalColor = new Vector3(1, 0.7, 0);
				
				var baseMaterials:Vector.<BaseMaterial> = new Vector.<BaseMaterial>();
				baseMaterials[0] = customMaterial1;
				baseMaterials[1] = customMaterial2;
				baseMaterials[2] = customMaterial3;
				baseMaterials[3] = customMaterial4;
				
				(dude.getChildAt(0).getChildAt(0) as SkinnedMeshSprite3D).skinnedMeshRenderer.sharedMaterials = baseMaterials;
				dude.transform.position = new Vector3(0, 0.5, 0);
				dude.transform.scale = new Vector3(0.2, 0.2, 0.2);
				dude.transform.rotate(new Vector3(0, 180, 0), false, false);
			}))
			
			var earth:MeshSprite3D = scene.addChild(new MeshSprite3D(PrimitiveMesh.createSphere(0.5, 128, 128))) as MeshSprite3D;
			
			var customMaterial:CustomMaterial = new CustomMaterial();
			Texture2D.load("res/threeDimen/texture/earth.png", Handler.create(null, function(tex:Texture2D):void{
				customMaterial.diffuseTexture = tex;
			}));
			customMaterial.marginalColor = new Vector3(0.0, 0.3, 1.0);
			earth.meshRenderer.sharedMaterial = customMaterial;
			
			Laya.timer.frameLoop(1, null, function():void {
				earth.transform.rotate(rotation, true);
			});
		}
		
		private function initShader():void {
			var attributeMap:Object = {
				'a_Position': VertexMesh.MESH_POSITION0, 
				'a_Normal': VertexMesh.MESH_NORMAL0, 
				'a_Texcoord': VertexMesh.MESH_TEXTURECOORDINATE0, 
				'a_BoneWeights': VertexMesh.MESH_BLENDWEIGHT0, 
				'a_BoneIndices': VertexMesh.MESH_BLENDINDICES0};
			var uniformMap:Object = {
				'u_Bones':Shader3D.PERIOD_CUSTOM, 
				'u_CameraPos': Shader3D.PERIOD_CAMERA, 
				'u_MvpMatrix': Shader3D.PERIOD_SPRITE, 
				'u_WorldMat': Shader3D.PERIOD_SPRITE, 
				'u_texture': Shader3D.PERIOD_MATERIAL, 
				'u_marginalColor': Shader3D.PERIOD_MATERIAL, 
				'u_DirectionLight.Direction': Shader3D.PERIOD_SCENE, 
				'u_DirectionLight.Color': Shader3D.PERIOD_SCENE};
			var vs:String = __INCLUDESTR__("customShader/glowingEdgeShader.vs");
			var ps:String = __INCLUDESTR__("customShader/glowingEdgeShader.ps");
			var customShader:Shader3D = Shader3D.add("CustomShader");
			var subShader:SubShader = new SubShader(attributeMap, uniformMap, SkinnedMeshSprite3D.shaderDefines);
			customShader.addSubShader(subShader);
			subShader.addShaderPass(vs,ps);
		}
	}
}