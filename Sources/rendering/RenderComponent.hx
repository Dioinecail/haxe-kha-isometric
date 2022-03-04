package rendering;

import gameObjects.Transform;
import kha.Image;
import kha.graphics4.TextureUnit;
import kha.graphics5.CullMode;
import kha.graphics5.CompareMode;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;
import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.graphics4.Graphics;
import kha.Assets;

class RenderComponent {
	private var transform:Transform;
	private var image:Image;

	private var vertexBuffer:VertexBuffer;
	private var indexBuffer:IndexBuffer;
	private var pipeline:PipelineState;
	private var textureID:TextureUnit;
	private var mvpID:ConstantLocation;



	public function new(transform:Transform, image:Image) {
		this.transform = transform;
		this.image = image;

		var structure = createVertexStruct();
		compilePipeline(structure);
		getShaderIDs();
		createBuffers(structure, 5);
	}
	
	public function render(g:Graphics) {
		// Bind data we want to draw
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		// Bind state we want to draw with
		g.setPipeline(pipeline);

		var pvMatrix = Main.camera.getPVMatrix();
		var mvp = pvMatrix.multmat(transform.trs);

		// Send our transformation to the currently bound shader, in the "MVP" uniform
		g.setMatrix(mvpID, mvp);
		g.setTexture(textureID, image);

		g.drawIndexedVertices();
    }

	private function createVertexStruct(): VertexStructure {
		// classic vertex buffer stuct
		var structure = new VertexStructure();
        structure.add("pos", VertexData.Float3); // vec3 in shader
        structure.add("uv", VertexData.Float2); // vec2 in shader
		
		return structure;
	}

	private function compilePipeline(structure:VertexStructure) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.s_simple_frag;
		pipeline.vertexShader = Shaders.s_simple_vert;

		pipeline.depthWrite = false;
		pipeline.depthMode = CompareMode.Less;
		pipeline.cullMode = CullMode.None;
		pipeline.compile();
	}

	private function getShaderIDs(){
		mvpID = pipeline.getConstantLocation("m");
		textureID = pipeline.getTextureUnit("tex2D");
	}

	private function createBuffers(structure:VertexStructure, structureLength:Int) {
		var obj = new ObjLoader(Assets.blobs.quad_obj);
		var data = obj.data;
		var indices = obj.indices;

		// Create vertex buffer
		vertexBuffer = new VertexBuffer(
			Std.int(data.length / structureLength),
			structure,
			Usage.DynamicUsage
		);
		
		// Copy vertices to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, data[i]);
		}
		vertexBuffer.unlock();

		// Create index buffer
		indexBuffer = new IndexBuffer(
			indices.length,
			Usage.StaticUsage
		);
		
		// Copy indices to index buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
	}
}