package game.databin.table
{
	import aurora.module.config.DataBinTable;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import game.databin.vo.TetrisLevelVO;

	/**
	 * Tetris.xlsx-TetrisLevelTable
	 * @author Auto created by ModuleEditor
	 */
	public class TetrisLevelTable extends DataBinTable
	{
		public function TetrisLevelTable()
		{
		}
		
		override public function binaryRead(data:ByteArray):void
		{
			if(data)
			{
				try
				{
					data.uncompress();
				}
				catch(e:Error)
				{
					trace("binaryRead:", e.message);
				}
				data.endian = Endian.BIG_ENDIAN; 
				data.position = 0;
				
				var len:int = data.readInt();
				var vo:TetrisLevelVO;
				table = new Array(len);
				var strtemp:String;
				for(var i:int = 0; i < len; ++i)
				{
					vo = new TetrisLevelVO();
					//编号-等级
					vo.id = data.readInt();
					//当前等级目标分数
					vo.target_score = data.readDouble();
					//当前等级速度
					vo.speed = data.readInt();

					table[i] = vo;
				}
				
				data.clear();
			}
		}
		

		
		public function getTetrisLevelVO(id:int):TetrisLevelVO
		{
			for each(var vo:TetrisLevelVO in table)
			{
				if(vo.id == id)
				{
					return vo;
				}
			}
			return null;
		}
		
	}
}
	