-- Cargar la espada y configurarla
local sword = LoadAssets(107336795603349):Get("Crescendo")
sword.Parent = character

local handle = sword:WaitForChild("Handle")

-- Configurar el sonido
local theme = Instance.new("Sound")
theme.Parent = character:WaitForChild("Torso")
theme.SoundId = "rbxassetid://12578363577"
theme.Looped = true
theme.Playing = true
theme.PlaybackSpeed = 1
theme.Volume = 1

-- Hacer las partes de la espada sin masa
for _, v in pairs(sword:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Massless = true
	end
end

-- Crear el weld para la espada
local weld = Instance.new("Motor6D")
weld.Parent = character:WaitForChild("Right Arm")
weld.Part0 = character:WaitForChild("Right Arm")
weld.Part1 = handle
weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), math.rad(180), 0)

-- Función para encontrar las partes del ojo
local function findEyeParts(eyeGroup)
	local base = eyeGroup:FindFirstChild("Base")
	if not base then
		error("No se pudo encontrar el objeto Base en el grupo: " .. eyeGroup.Name)
	end

	local center = base:FindFirstChild("Center")
	local left = base:FindFirstChild("Left")
	local right = base:FindFirstChild("Right")

	if not (center and left and right) then
		error("No se pudieron encontrar todos los objetos en Base dentro del grupo de ojos: " .. eyeGroup.Name)
	end

	return base, center, left, right
end

-- Buscar los ojos en la espada
local Eye_Normal1 = sword:FindFirstChild("Eye_Normal")
local Eye_Normal2 = sword:FindFirstChild("Eye_Normal2")

if not (Eye_Normal1 and Eye_Normal2) then
    error("No se encontraron los grupos Eye_Normal1 o Eye_Normal2 en la espada")
end

-- Buscar las partes de los ojos
local Base1, Center1, Left1, Right1 = findEyeParts(Eye_Normal1)
local Base2, Center2, Left2, Right2 = findEyeParts(Eye_Normal2)

-- Función para mover las partes de los ojos suavemente usando CFrame
local function tweenEyePosition(eye, endCFrame, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(eye, tweenInfo, {CFrame = endCFrame})
	tween:Play()
	return tween
end

-- Función para animar el movimiento de los ojos
local function animateEyeMovement(centerEye, leftEye, rightEye, direction)
	if direction == "right" then
		tweenEyePosition(centerEye, CFrame.new(0.8, 0, 0), 0.5)
		tweenEyePosition(leftEye, CFrame.new(0.7, 0, 0), 0.5)
		tweenEyePosition(rightEye, CFrame.new(0.9, 0, 0), 0.5)
	elseif direction == "left" then
		tweenEyePosition(centerEye, CFrame.new(-0.8, 0, 0), 0.5)
		tweenEyePosition(leftEye, CFrame.new(-0.7, 0, 0), 0.5)
		tweenEyePosition(rightEye, CFrame.new(-0.9, 0, 0), 0.5)
	else
		-- Volver al centro
		tweenEyePosition(centerEye, CFrame.new(0, 0, 0), 0.5)
		tweenEyePosition(leftEye, CFrame.new(-0.1, 0, 0), 0.5)
		tweenEyePosition(rightEye, CFrame.new(0.1, 0, 0), 0.5)
	end
end

-- Función original para agitar un objeto (Base o partes de los ojos) - opcional
local function shakeObject(object)
	local originalPosition = object.Position
	while true do
		local offsetX = math.random(-1, .7) * 1
		local offsetY = math.random(-1, .7) * 1
		object.Position = originalPosition + UDim2.new(0, offsetX, 0, offsetY)
		wait(0.025)
	end
end

-- Función para manejar la animación completa de ambos ojos
local function animateBothEyes(Base1, Center1, Left1, Right1, Base2, Center2, Left2, Right2)
	-- Puedes activar la agitación solo si es necesario
	coroutine.wrap(function()
		shakeObject(Base1) -- Agita solo si lo deseas
		shakeObject(Base2)
	end)()

	while true do
		-- Movimiento hacia la derecha
		animateEyeMovement(Center1, Left1, Right1, "right")
		animateEyeMovement(Center2, Left2, Right2, "right")
		wait(1)

		-- Volver al centro
		animateEyeMovement(Center1, Left1, Right1, "center")
		animateEyeMovement(Center2, Left2, Right2, "center")
		wait(1)

		-- Movimiento hacia la izquierda
		animateEyeMovement(Center1, Left1, Right1, "left")
		animateEyeMovement(Center2, Left2, Right2, "left")
		wait(1)

		-- Volver al centro
		animateEyeMovement(Center1, Left1, Right1, "center")
		animateEyeMovement(Center2, Left2, Right2, "center")
		wait(1)
	end
end

-- Ejecutar la animación de los ojos
animateBothEyes(Base1, Center1, Left1, Right1, Base2, Center2, Left2, Right2)
