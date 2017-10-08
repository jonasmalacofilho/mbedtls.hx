package fast;

import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.ExprTools;

class Devector {
	public static macro function init(ident:Expr, size:Int)
	{
		var ident = ident.toString();
		var vars = [for (i in 0...size) { name:'${ident}_$i', type:null, expr:null }];
		return { expr:EVars(vars), pos:Context.currentPos() };
	}

	static function unrollTransform(e:Expr, i:Int, jname:String, idents:Array<String>, force:Bool):Expr
	{
		return switch e {
		case macro $i{ident} if (force && ident == jname):
			macro $v{i};
		case macro $i{array}[$index] if (idents.indexOf(array) >= 0):
			var index = unrollTransform(index, i, jname, idents, true);
			var computedIndex = index.getValue();
			var uvalue = '${array}_$computedIndex';
			macro $i{uvalue};
		case _:
			e.map(unrollTransform.bind(_, i, jname, idents, force));
		}
	}

	public static macro function unroll(loop:Expr, idents:Array<Expr>)
	{
		switch loop {
		case macro for ($j in $min...$max) $expr:
			var jname = j.toString();
			var min:Int = min.getValue();
			var max:Int = max.getValue();
			var idents = [for (i in idents) switch i.expr { case EConst(CIdent(name)): name; case _: throw "Failed"; }];
			var block = [];
			block.push(macro var $jname);
			for (i in min...max) {
				block.push(macro $i{jname} = $v{i});
				block.push(unrollTransform(expr, i, jname, idents, false));
			}
			return macro $b{block};
		case _:
			return macro null;
		}
	}
}

