if IsFinalBuild() then
	PainMenu._Draw = PainMenu.Draw

	function PainMenu:Draw()
		if Cfg.Fullscreen then
			R3D.SetContrastGammaAndBrightness( 0.5, 1.0, 0.5 )
		end
		R3D.ApplyVideoSettings( Cfg.Resolution, Cfg.Fullscreen, Cfg.Gamma, Cfg.Brightness, Cfg.Contrast, Cfg.Shadows, Cfg.TextureQuality, Cfg.WeatherEffects, Cfg.ViewWeaponModel, Cfg.TextureFiltering, Cfg.DynamicLights, Cfg.Projectors, Cfg.Coronas, Cfg.Decals, Cfg.DecalsStay )
		self:_Draw()
	end

	PainMenu._ApplyVideoSettings = PainMenu.ApplyVideoSettings

	function PainMenu:ApplyVideoSettings()
		if Cfg.Fullscreen then
			R3D.SetContrastGammaAndBrightness( 0.5, 1.0, 0.5 )
		end
		self:_ApplyVideoSettings()
	end
end