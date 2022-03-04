package rendering;

import kha.graphics5.VertexData;
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

class InstancedBatch {
	var instances : Array<InstancedRenderComponent>;
	
	var vertexBuffers: Array<VertexBuffer>;
	var indexBuffer: IndexBuffer;
	var pipeline: PipelineState;
	var image:Image;
	var textureID:TextureUnit;



	public function new(instances:Array<InstancedRenderComponent>, image:Image) {
		this.instances = instances;
		this.image = image;
		
		var obj = new ObjLoader(Assets.blobs.quad_obj);
		var structures = createStructures();

		createBuffers(obj.data, obj.indices, structures);
		setupPipeline(structures);

		textureID = pipeline.getTextureUnit("tex2D");
    }

	public function render(g:Graphics) {
		g.setPipeline(pipeline);
		
		var pvMatrix = Main.camera.getPVMatrix();
		var mvp = FastMatrix4.identity();
		
		// Fill transformation matrix buffer with values from each instance
		var mData = vertexBuffers[2].lock();
		for (i in 0...instances.length) {
			mvp = pvMatrix.multmat(instances[i].getModelMatrix());
			
			mData.set(i * 16 + 0, mvp._00);		
			mData.set(i * 16 + 1, mvp._01);		
			mData.set(i * 16 + 2, mvp._02);		
			mData.set(i * 16 + 3, mvp._03);		
			
			mData.set(i * 16 + 4, mvp._10);		
			mData.set(i * 16 + 5, mvp._11);		
			mData.set(i * 16 + 6, mvp._12);		
			mData.set(i * 16 + 7, mvp._13);		
			
			mData.set(i * 16 + 8, mvp._20);		
			mData.set(i * 16 + 9, mvp._21);		
			mData.set(i * 16 + 10, mvp._22);		
			mData.set(i * 16 + 11, mvp._23);		
			
			mData.set(i * 16 + 12, mvp._30);		
			mData.set(i * 16 + 13, mvp._31);		
			mData.set(i * 16 + 14, mvp._32);		
			mData.set(i * 16 + 15, mvp._33);		
		}

		vertexBuffers[2].unlock();

		// Instanced rendering
		if(g.instancedRenderingAvailable()) {
			g.setVertexBuffers(vertexBuffers);
			g.setIndexBuffer(indexBuffer);
			g.setTexture(textureID, image);
			g.drawIndexedVerticesInstanced(instances.length);
		}
    }

	private function createStructures(): Array<VertexStructure> {
		var structures = new Array<VertexStructure>();
		
		structures[0] = new VertexStructure();
        structures[0].add("pos", VertexData.Float3);
		structures[0].add("uv", VertexData.Float2);
		
		// Color structure, is different for each instance
		structures[1] = new VertexStructure();
        structures[1].add("tint", VertexData.Float3);
		
		// Transformation matrix, is different for each instance
		structures[2] = new VertexStructure();
		structures[2].add("m", VertexData.Float4x4);
		
		return structures;
	}

	private function createBuffers(vertexData:Array<Float>, indices:Array<Int>, structures:Array<VertexStructure>) {

		// Vertex buffer [0]
		vertexBuffers = new Array();
		vertexBuffers[0] = new VertexBuffer(
			Std.int(vertexData.length / 5),
			structures[0],
			Usage.StaticUsage
		);
		
		// fill "pos" and "uv" data
		var vbData = vertexBuffers[0].lock();
		for (i in 0...vbData.length) {
			vbData.set(i, vertexData[i]);
		}
		vertexBuffers[0].unlock();
		
		// Vertex buffer [1]
		vertexBuffers[1] = new VertexBuffer(
			instances.length,
			structures[1],
			Usage.StaticUsage,
			1 // changed after every instance, use i higher number for repetitions
		);
		
		// fill "tint" data
		var tintData = vertexBuffers[1].lock();
		for (i in 0...instances.length) {
			tintData.set(i * 3, 1);
			tintData.set(i * 3 + 1, 1);
			tintData.set(i * 3 + 2, 1);
		}
		vertexBuffers[1].unlock();
		
		vertexBuffers[2] = new VertexBuffer(
			instances.length,
			structures[2],
			Usage.StaticUsage,
			1 // changed after every instance, use i higher number for repetitions
		);

		// Index buffer
		indexBuffer = new IndexBuffer(
			indices.length,
			Usage.StaticUsage
		);
		
		// fill indices buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
	}

	private function setupPipeline(structures:Array<VertexStructure>) {
		// Setup pipeline
		pipeline = new PipelineState();
		pipeline.fragmentShader = Shaders.s_simple_frag;
		pipeline.vertexShader = Shaders.s_simple_vert;
		pipeline.inputLayout = structures;
		pipeline.depthWrite = false;
		pipeline.depthMode = CompareMode.Less;
		pipeline.cullMode = CullMode.Clockwise;
		pipeline.compile();
	}
}