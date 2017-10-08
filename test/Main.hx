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
			runner.addCase(new TestSha256());

#if instrument
			runner.onComplete.add(function (_) trace(printTimers()));
#end
			utest.ui.Report.create(runner);

			runner.run();
		case [path]:
			var bytes = sys.io.File.getBytes(path);
			var ti = Sys.time();
			var h = fast.Sha256.make(bytes);
			var tf = Sys.time();
			Sys.stderr().writeString('Took ${Math.round(1e3*(tf - ti))}ms\n');
			Sys.stdout().writeString('${h.toHex()}  $path');
#if instrument
			Sys.stderr().writeString(printTimers());
#end
		}

	}
}

