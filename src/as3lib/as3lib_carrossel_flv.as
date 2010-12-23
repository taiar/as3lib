package as3lib
{
	import flash.utils.ByteArray;
	import flash.events.*;
	import fl.video.*;
	

	/**
	 * Classe responsável por carregar em ordem de atividade os clips.
	 * Diferente da versão inicial do nosso sistema, ela não trabalha
	 * com o arquivo de configuração e nem com o menu administrativo.
	 * As listas de clips e dados em geral devem ser setados com os 
	 * métodos da classe
	 */
	public class as3lib_carrossel_flv
	{
		public var sources:Array;//lista dos paths dos clips que serão carregados
		public var ativos:Array;//lista dos estados dos clips

		private var atual:int;//estado atual do carrossel
		private var total:int;//quantidade de clips no carrossel

		public var player:FLVPlayback;

		private var target:Object;//objeto ao qual os clips serão anexados

		/**
		 * Construtor - inicia valores e objetos e adiciona o player ao objeto 
		 * passado como parâmetro.
		 */
		public function as3lib_carrossel_flv(o:Object):void
		{
			this.atual = 0;
			this.total = 0;
			this.player = new FLVPlayback();
			this.target = o;
			this.target.addChild(this.player);
			//addChild(this.player);
			this.posiciona();
		}

		/**
		 * Seta valores para a lista dos paths dos clips
		 */
		public function setSources(a:Array):void
		{
			this.sources = as3lib_carrossel_flv.clone(a);
			this.total = this.sources.length;
		}

		/**
		 * Seta lista de atividades dos clips
		 */
		public function setAtivos(a:Array):void
		{
			this.ativos = as3lib_carrossel_flv.clone(a);
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

		/**
		 * Inicia o carrossel
		 */
		public function start():void
		{
			if (this.verificaAtivos())
			{
				while (this.ativos[this.atual] == "false")
				{
					this.atual +=  1;
				}
				this.player.source = this.sources[this.atual];
				this.target.addChild(this.player);
				//addChild(this.player);
				this.player.addEventListener(VideoEvent.COMPLETE, this.next);
			}
		}

		/**
		 * Carrega o próximo video
		 */
		public function next(v:VideoEvent):void
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
			this.target.removeChild(this.player);
			//removeChild(this.player);
			this.start();
		}
		
		private function posiciona():void
		{
			this.player.width = 1360;
			this.player.height = 768;
			this.player.rotation = -90;
			this.player.y = 1360;
		}
		
		/**
		 * Para o carrossel
		 * FIXME: Precisa de Flags para verificar se o filme já está parado
		 */
		public function stop():void
		{
			this.target.removeChild(this.player);
			//removeChild(this.player);
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