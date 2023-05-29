local sin = math.sin
local cos = math.cos
local pi = math.pi
local Period = 2 * pi --Periodicity of the function (can be time basically).
local Iterations = 100 --Number of terms in the Fourier Series.
local Steps = 300

function S(x) --The function to be expanded into trig sums.
	return cos(x) * 3 + sin(2 * x) * 4
end

function Integral(Function, LowerBound, UpperBound, Division)
	local Result = 0
	local Distance = UpperBound - LowerBound
	local Delta = Distance / Division

	for x = LowerBound, UpperBound, Delta do
		Result += Function(x) * Delta
	end

	return Result
end

--Note that S(x) can be any function, periodic or not.

function ReturnArea()
	local A0 = Integral(S, -Period / 2, Period / 2, Steps)
	
	A0 /= Period
	
	return A0
end

function ReturnCoefficients(n)
	local An = Integral(function(x)
		return S(x) * cos( (2 * pi * n * x) / Period )
	end, -Period / 2, Period / 2, Steps)
	
	local Bn = Integral(function(x)
		return S(x) * sin( (2 * pi * n * x) / Period )
	end, -Period / 2, Period / 2, Steps)
	
	An *= 2 / Period
	Bn *= 2 / Period
	
	return An, Bn
end

local A0 = ReturnArea()

function FourierSeries(x)
	local CosineSum = 0
	local SineSum = 0
	
	for n = 1, Iterations do
		local An, Bn = ReturnCoefficients(n)
		CosineSum += An * cos( (2 * pi * n * x) / Period )
		SineSum += Bn * sin( (2 * pi * n * x) / Period )
	end
	
	return A0 + CosineSum + SineSum
end

print("Original function at x = 1:", S(1))
print("Fourier series at x = 1:", FourierSeries(1))

local Parts = {}
local Parts2 = {}

for i = -2, 2, 4 / 200 do
	local Part = Instance.new("Part", workspace.bobmanthe3rd)
	Part.Size = Vector3.one
	Part.Anchored = true

	local Part2 = Instance.new("Part", workspace.bobmanthe3rd)
	Part2.Size = Vector3.one
	Part2.Anchored = true
	Part2.Color = Color3.new(0, 0, 0)
	Part2.Material = Enum.Material.Neon
	
	local Index = (i * 100) / 2
	
	Parts[Index] = Part
	Parts2[Index] = Part2
end

--task.wait(20)

for i = 1, 1 do
	
	for i = -2, 2, 4 / 200 do
		local x = i * Period
		local Value = S(x)
		local Approximation = FourierSeries(x)
		local Index = (i * 100) / 2

		Parts[Index].Position = Vector3.new(Index, Value, 0) + Vector3.yAxis * 20
		Parts2[Index].Position = Vector3.new(Index, Approximation, 0) + Vector3.yAxis * 50
	end
	
	task.wait(1 / 30)
end
