using StringTools;

class Main {
#if instrument
	static var timers:Map<String,{ count:Int, time:Float }>;

	static function printTimers()
	{
		var values = [ for (k in timers.keys()) { key:k, val:timers[k] } ];
		values.sort(function (a,b) return Reflect.compare(b.val.time, a.val.time));
		var buf = new StringBuf();
		buf.add("timers:\n");
		for (val in values) {
			var k = val.key;
			var v = val.val;
			var tcall = v.count > 0 ? v.time/v.count : 0.;
			var totalScale = instrument.TimeCalls.autoScale(v.time);
			var callScale = instrument.TimeCalls.autoScale(tcall);
			buf.add('  ${k}: ${v.count} calls, ${Math.round(tcall*callScale.divisor)}${callScale.symbol}/call, ${Math.round(v.time*totalScale.divisor)}${totalScale.symbol} in total\n');
		}
		return buf.toString();
	}
#end

	static function main()
	{
#if instrument
		timers = new Map();
		var defaultOnTimed = instrument.TimeCalls.onTimed;
		instrument.TimeCalls.onTimed = function (start, finish, ?pos:haxe.PosInfos) {
			var key = '${pos.className}.${pos.methodName}';
			if (timers.exists(key)) {
				var t = timers[key];
				t.count++;
				t.time += finish - start;
			} else {
				timers[key] = { count:1, time:(finish - start) };
			}
		}
#end

		switch Sys.args() {
		case []:
			var runner = new utest.Runner();
			runner.addCase(new TestMd5());
			runner.addCase(new TestSha1());
			runner.addCase(new TestSha224());
			runner.addCase(new TestSha256());
			runner.addCase(new TestSha384());
			runner.addCase(new TestSha512());

#if instrument
			runner.onComplete.add(function (_) trace(printTimers()));
#end
			utest.ui.Report.create(runner);

			runner.run();
		case args if (args[0].endsWith("sum") && args.length > 1):
			var algo = args[0].substr(0, args[0].indexOf("sum"));
			var Impl:{ make:haxe.io.Bytes->haxe.io.Bytes } = cast Type.resolveClass('mbedtls.${algo.charAt(0).toUpperCase()}${algo.substr(1)}');
			if (Impl == null) {
				Sys.stderr().writeString('Could not find suitable implementation for $algo');
				Sys.exit(1);
			}
			for (path in args.slice(1)) {
				var bytes = sys.io.File.getBytes(path);
				var hash = Impl.make(bytes);
				Sys.stdout().writeString('${hash.toHex()}  $path\n');
			}
#if instrument
			Sys.stderr().writeString(printTimers());
#end
		case other:
			Sys.stderr().writeString('Usage:\n  test.n\n  test.n sha256sum <path> [<path>...]\n');
			Sys.exit(1);
		}

	}
}

