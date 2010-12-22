package as3lib
{
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Classe responsável por carregar em ordem de atividade os clips.
	 * Diferente da versão inicial do nosso sistema, ela não trabalha
	 * com o arquivo de configuração e nem com o menu administrativo.
	 * As listas de clips e dados em geral devem ser setados com os 
	 * métodos da classe
	 */
	public class as3lib_carrossel
	{
		public var sources:Array;//lista dos paths dos clips que serão carregados
		public var ativos:Array;//lista dos estados dos clips

		private var atual:int;//estado atual do carrossel
		private var total:int;//quantidade de clips no carrossel

		private var requester:URLRequest;//faz o request aos clips que serão carregados
		private var loader:URLLoader;//carrega dos clips requisitados

		private var layer:Sprite;//layer aonde os clips serão exibidos

		private var target:Object;//objeto ao qual os clips serão anexados

		public function as3lib_carrossel(o:Object):void
		{
			this.atual = 0;
			this.total = 0;
			this.requester = new URLRequest();
			this.loader = new URLLoader();
			this.layer = new Sprite();
			this.target = o;
			this.target.addChild(this.layer);
		}

		/**
		 * Seta valores para a lista dos paths dos clips
		 */
		public function setSources(a:Array):void
		{
			this.sources = as3lib_carrossel.clone(a);
			this.total = this.sources.length;
		}

		/**
		 * Seta lista de atividades dos clips
		 */
		public function setAtivos(a:Array):void
		{
			this.ativos = as3lib_carrossel.clone(a);
		}

		/**
		 * Reseta valores do carrossel
		 */
		public function reset():void
		{
			this.atual = 0;
			this.total = 0;
			this.sources = [];
			this.ativos = [];
		}

		public function start():void
		{
			this.requester.url = this.sources[this.atual];
			this.loader.load(this.requester);
			this.loader.addEventListener(Event.COMPLETE, this.setFrameListener);
			
			this.layer.addChild(this.loader as MovieClip);
		}

		private function checkFrame(e:Event):void
		{
			if ((e.currentTarget as MovieClip).totalFrames == (e.currentTarget as MovieClip).currentFrame)
			{
				(e.currentTarget as MovieClip).removeEventListener(Event.ENTER_FRAME, this.checkFrame);
				this.next();
			}
		}

		public function next():void
		{
			this.atual +=  1;
			if (this.atual >= this.total)
			{
				this.atual = 0;
			}
			while (this.ativos[this.atual] == "false")
			{
				this.atual +=  1;
				if (this.atual >= this.total)
				{
					this.atual = 0;
				}
			}
			this.requester.url = this.sources[this.atual];
			this.layer.removeChild(this.loader as MovieClip);
			this.loader.load(this.requester);
			this.layer.addChild(this.loader as MovieClip);
		}

		/**
		 * Verifica se existem promoções ativas
		 */
		private function verificaAtivos():Boolean
		{
			var i:int = 0;
			for (i =0; i < this.total; i += 1)
			{
				if (this.ativos[i] == "true")
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Clona arrays
		 */
		public static function clone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray  ;
			myBA.writeObject(source);
			myBA.position = 0;
			return (myBA.readObject());
		}
	}
}