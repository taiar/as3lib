package as3lib
{
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
		private var loader:Loader;//carrega dos clips requisitados

		private var layer:Sprite;//layer aonde os clips serão exibidos

		public function as3lib_carrossel()
		{

		}

		/**
		 * Seta valores para a lista dos paths dos clips
		 */
		public function setSources(a:Array)
		{
			this.sources = as3lib_carrossel.clone(a);
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