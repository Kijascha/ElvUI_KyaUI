local KYA, E, L, V, P, G = unpack(select(2, ...))

function KYA:LoadDetailsProfile()
	local font = "PT Sans Narrow"
	local key = KYA.AddonProfileKey

	if _detalhes_global["__profiles"][key] == nil then
		_detalhes_global["__profiles"][key] = {
			["show_arena_role_icon"] = false,
			["capture_real"] = {
				["heal"] = true,
				["spellcast"] = true,
				["miscdata"] = true,
				["aura"] = true,
				["energy"] = true,
				["damage"] = true,
			},
			["row_fade_in"] = {
				"in", -- [1]
				0.2, -- [2]
			},
			["streamer_config"] = {
				["faster_updates"] = false,
				["quick_detection"] = false,
				["reset_spec_cache"] = false,
				["no_alerts"] = false,
				["disable_mythic_dungeon"] = false,
				["use_animation_accel"] = true,
			},
			["all_players_are_group"] = false,
			["use_row_animations"] = true,
			["report_heal_links"] = false,
			["remove_realm_from_name"] = true,
			["minimum_overall_combat_time"] = 10,
			["event_tracker"] = {
				["enabled"] = false,
				["font_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["line_height"] = 16,
				["line_color"] = {
					0.1, -- [1]
					0.1, -- [2]
					0.1, -- [3]
					0.3, -- [4]
				},
				["font_shadow"] = "NONE",
				["font_size"] = 10,
				["font_face"] = "Friz Quadrata TT",
				["frame"] = {
					["show_title"] = true,
					["strata"] = "LOW",
					["backdrop_color"] = {
						0.16, -- [1]
						0.16, -- [2]
						0.16, -- [3]
						0.47, -- [4]
					},
					["locked"] = true,
					["height"] = _G.RightChatDataPanel:GetHeight(),
					["width"] = _G.RightChatDataPanel:GetWidth()/2,

				},
				["line_texture"] = "Details Serenity",
				["options_frame"] = {
				},
			},
			["report_to_who"] = "",
			["class_specs_coords"] = {
				[62] = {
					0.251953125, -- [1]
					0.375, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[63] = {
					0.375, -- [1]
					0.5, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[250] = {
					0, -- [1]
					0.125, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[251] = {
					0.125, -- [1]
					0.25, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[252] = {
					0.25, -- [1]
					0.375, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[253] = {
					0.875, -- [1]
					1, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[254] = {
					0, -- [1]
					0.125, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[255] = {
					0.125, -- [1]
					0.25, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[66] = {
					0.125, -- [1]
					0.25, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[257] = {
					0.5, -- [1]
					0.625, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[258] = {
					0.6328125, -- [1]
					0.75, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[259] = {
					0.75, -- [1]
					0.875, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[260] = {
					0.875, -- [1]
					1, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[577] = {
					0.25, -- [1]
					0.375, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[262] = {
					0.125, -- [1]
					0.25, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[581] = {
					0.375, -- [1]
					0.5, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[264] = {
					0.375, -- [1]
					0.5, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[265] = {
					0.5, -- [1]
					0.625, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[266] = {
					0.625, -- [1]
					0.75, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[267] = {
					0.75, -- [1]
					0.875, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[268] = {
					0.625, -- [1]
					0.75, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[269] = {
					0.875, -- [1]
					1, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[270] = {
					0.75, -- [1]
					0.875, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[70] = {
					0.251953125, -- [1]
					0.375, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[102] = {
					0.375, -- [1]
					0.5, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[71] = {
					0.875, -- [1]
					1, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[103] = {
					0.5, -- [1]
					0.625, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[72] = {
					0, -- [1]
					0.125, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[104] = {
					0.625, -- [1]
					0.75, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[73] = {
					0.125, -- [1]
					0.25, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[64] = {
					0.5, -- [1]
					0.625, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[105] = {
					0.75, -- [1]
					0.875, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[65] = {
					0, -- [1]
					0.125, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[256] = {
					0.375, -- [1]
					0.5, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[261] = {
					0, -- [1]
					0.125, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[263] = {
					0.25, -- [1]
					0.375, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
			},
			["profile_save_pos"] = true,
			["tooltip"] = {
				["header_statusbar"] = {
					0.3, -- [1]
					0.3, -- [2]
					0.3, -- [3]
					0.8, -- [4]
					false, -- [5]
					false, -- [6]
					"WorldState Score", -- [7]
				},
				["fontcolor_right"] = {
					1, -- [1]
					0.7, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["line_height"] = 17,
				["tooltip_max_targets"] = 2,
				["icon_size"] = {
					["W"] = 17,
					["H"] = 17,
				},
				["tooltip_max_pets"] = 2,
				["anchor_relative"] = "top",
				["abbreviation"] = 2,
				["anchored_to"] = 1,
				["show_amount"] = false,
				["header_text_color"] = {
					1, -- [1]
					0.9176, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["fontsize"] = 10,
				["background"] = {
					0.196, -- [1]
					0.196, -- [2]
					0.196, -- [3]
					0.8, -- [4]
				},
				["submenu_wallpaper"] = true,
				["fontsize_title"] = 10,
				["fontcolor"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["commands"] = {
				},
				["tooltip_max_abilities"] = 6,
				["fontface"] = "Friz Quadrata TT",
				["border_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["border_texture"] = "Details BarBorder 3",
				["anchor_offset"] = {
					0, -- [1]
					0, -- [2]
				},
				["menus_bg_texture"] = "Interface\\SPELLBOOK\\Spellbook-Page-1",
				["maximize_method"] = 1,
				["border_size"] = 14,
				["fontshadow"] = false,
				["anchor_screen_pos"] = {
					507.7, -- [1]
					-350.5, -- [2]
				},
				["anchor_point"] = "bottom",
				["menus_bg_coords"] = {
					0.309777336120606, -- [1]
					0.924000015258789, -- [2]
					0.213000011444092, -- [3]
					0.279000015258789, -- [4]
				},
				["icon_border_texcoord"] = {
					["R"] = 0.921875,
					["L"] = 0.078125,
					["T"] = 0.078125,
					["B"] = 0.921875,
				},
				["menus_bg_color"] = {
					0.8, -- [1]
					0.8, -- [2]
					0.8, -- [3]
					0.2, -- [4]
				},
			},
			["ps_abbreviation"] = 3,
			["world_combat_is_trash"] = false,
			["update_speed"] = 0.05000000074505806,
			["bookmark_text_size"] = 11,
			["animation_speed_mintravel"] = 0.45,
			["track_item_level"] = true,
			["windows_fade_in"] = {
				"in", -- [1]
				0.2, -- [2]
			},
			["instances_menu_click_to_open"] = false,
			["overall_clear_newchallenge"] = true,
			["current_dps_meter"] = {
				["enabled"] = false,
				["font_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["arena_enabled"] = true,
				["font_shadow"] = "NONE",
				["font_size"] = 18,
				["mythic_dungeon_enabled"] = true,
				["sample_size"] = 5,
				["font_face"] = font,
				["frame"] = {
					["show_title"] = false,
					["strata"] = "LOW",
					["backdrop_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						0.2, -- [4]
					},
					["locked"] = false,
					["height"] = _G.RightChatDataPanel:GetHeight(),
					["width"] = _G.RightChatDataPanel:GetWidth()/2,
				},
				["update_interval"] = 0.3,
				["options_frame"] = {
				},
			},
			["data_cleanup_logout"] = false,
			["instances_disable_bar_highlight"] = false,
			["trash_concatenate"] = false,
			["color_by_arena_team"] = true,
			["animation_speed"] = 33,
			["disable_stretch_from_toolbar"] = false,
			["disable_lock_ungroup_buttons"] = true,
			["memory_ram"] = 64,
			["disable_window_groups"] = false,
			["instances_suppress_trash"] = 0,
			["options_window"] = {
				["scale"] = 1,
			},
			["animation_speed_maxtravel"] = 3,
			["instances_segments_locked"] = true,
			["deadlog_limit"] = 16,
			["font_faces"] = {
				["menus"] = "Continuum Medium",
			},
			["instances_no_libwindow"] = false,
			["segments_amount"] = 18,
			["data_broker_text"] = "",
			["instances"] = {
				{
					["__pos"] = {
						["normal"] = {
							["y"] = -360,
							["x"] = 662,
							["w"] = 200,
							["h"] = 165,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["hide_in_combat_type"] = 1,
					["clickthrough_window"] = false,
					["menu_anchor"] = {
						19, -- [1]
						1, -- [2]
						["side"] = 2,
					},
					["bg_r"] = 0,
					["hide_out_of_combat"] = false,
					["color_buttons"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons",
					["micro_displays_locked"] = true,
					["fontstrings_width"] = 35,
					["tooltip"] = {
						["n_abilities"] = 3,
						["n_enemies"] = 3,
					},
					["switch_all_roles_in_combat"] = false,
					["clickthrough_toolbaricons"] = false,
					["row_info"] = {
						["textR_outline"] = false,
						["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal_alpha",
						["textL_outline"] = false,
						["textR_outline_small"] = true,
						["textR_show_data"] = {
							true, -- [1]
							true, -- [2]
							false, -- [3]
						},
						["percent_type"] = 1,
						["fixed_text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["space"] = {
							["right"] = 0,
							["left"] = 0,
							["between"] = 1,
						},
						["texture_background_class_color"] = false,
						["textL_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["font_face_file"] = "Interface\\AddOns\\ElvUI\\Media\\Fonts\\ContinuumMedium.ttf",
						["backdrop"] = {
							["enabled"] = false,
							["size"] = 0.5,
							["color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0, -- [4]
							},
							["texture"] = "Details BarBorder 2",
						},
						["font_size"] = 10,
						["textL_translit_text"] = false,
						["texture_custom_file"] = "Interface\\",
						["texture_file"] = "Interface\\AddOns\\ElvUI_KyaUI\\media\\Textures\\BuiOnePixel.tga",
						["textR_bracket"] = "<",
						["models"] = {
							["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
							["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
							["upper_alpha"] = 0.5,
							["lower_enabled"] = false,
							["lower_alpha"] = 0.1,
							["upper_enabled"] = false,
						},
						["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
						["icon_grayscale"] = false,
						["textL_custom_text"] = "{data1}. {data3}{data2}",
						["use_spec_icons"] = true,
						["textR_enable_custom_text"] = false,
						["textL_enable_custom_text"] = false,
						["fixed_texture_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["textL_show_number"] = true,
						["texture_custom"] = "",
						["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
						["textR_custom_text"] = "{data1}. {data3}",
						["texture"] = "KyaOnePixel",
						["start_after_icon"] = true,
						["texture_background_file"] = "Interface\\AddOns\\ElvUI_KyaUI\\media\\Textures\\BuiOnePixel.tga",
						["textL_class_colors"] = true,
						["alpha"] = 0.8,
						["texture_background"] = "KyaOnePixel",
						["textR_class_colors"] = false,
						["textR_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["no_icon"] = false,
						["icon_offset"] = {
							0, -- [1]
							0, -- [2]
						},
						["fixed_texture_background_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["font_face"] = "Continuum Medium",
						["texture_class_colors"] = true,
						["textL_outline_small"] = true,
						["fast_ps_update"] = false,
						["textR_separator"] = "|",
						["height"] = 19,
					},
					["switch_tank"] = false,
					["plugins_grow_direction"] = true,
					["menu_icons"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						false, -- [6]
						["space"] = 0,
						["shadow"] = false,
					},
					["desaturated_menu"] = false,
					["micro_displays_side"] = 2,
					["window_scale"] = 1,
					["hide_icon"] = false,
					["toolbar_side"] = 2,
					["bg_g"] = 0,
					["menu_icons_alpha"] = 0.5,
					["bg_b"] = 0,
					["switch_healer_in_combat"] = false,
					["color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["hide_on_context"] = {
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [1]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [2]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [3]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [4]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [5]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [6]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [7]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [8]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [9]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [10]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [11]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [12]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [13]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [14]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [15]
					},
					["skin"] = "Dark Theme",
					["following"] = {
						["enabled"] = false,
						["bar_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["switch_healer"] = false,
					["fontstrings_text2_anchor"] = 74,
					["__snapV"] = false,
					["__snapH"] = false,
					["StatusBarSaved"] = {
						["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
						["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
						["options"] = {
							["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
								["isHidden"] = false,
								["segmentType"] = 2,
								["textFace"] = "Oswald",
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textAlign"] = 3,
								["timeType"] = 1,
								["textSize"] = 9,
								["textYMod"] = 0,
							},
							["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
								["isHidden"] = false,
								["segmentType"] = 2,
								["textFace"] = "Oswald",
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textAlign"] = 1,
								["timeType"] = 1,
								["textSize"] = 9,
								["textYMod"] = 0,
							},
							["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
								["isHidden"] = false,
								["segmentType"] = 2,
								["textFace"] = "Oswald",
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textAlign"] = 2,
								["timeType"] = 1,
								["textSize"] = 9,
								["textYMod"] = 0,
							},
						},
						["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
					},
					["grab_on_top"] = false,
					["__was_opened"] = true,
					["instance_button_anchor"] = {
						-27, -- [1]
						1, -- [2]
					},
					["version"] = 3,
					["fontstrings_text4_anchor"] = 3,
					["__locked"] = true,
					["menu_alpha"] = {
						["enabled"] = false,
						["onleave"] = 1,
						["ignorebars"] = false,
						["iconstoo"] = true,
						["onenter"] = 1,
					},
					["switch_all_roles_after_wipe"] = false,
					["row_show_animation"] = {
						["anim"] = "Fade",
						["options"] = {
						},
					},
					["bars_inverted"] = false,
					["strata"] = "LOW",
					["clickthrough_incombatonly"] = true,
					["__snap"] = {
						[3] = 2,
					},
					["stretch_button_side"] = 1,
					["hide_in_combat_alpha"] = 0,
					["bars_sort_direction"] = 1,
					["show_statusbar"] = true,
					["libwindow"] = {
						["y"] = 74.9997329711914,
						["x"] = -198,
						["point"] = "BOTTOMRIGHT",
						["scale"] = 1,
					},
					["statusbar_info"] = {
						["alpha"] = 1,
						["overlay"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
					},
					["backdrop_texture"] = "None",
					["menu_anchor_down"] = {
						19, -- [1]
						-2, -- [2]
					},
					["bg_alpha"] = 0,
					["switch_tank_in_combat"] = false,
					["bars_grow_direction"] = 1,
					["switch_damager_in_combat"] = false,
					["icon_desaturated"] = false,
					["clickthrough_rows"] = false,
					["auto_current"] = true,
					["attribute_text"] = {
						["show_timer"] = true,
						["shadow"] = false,
						["side"] = 1,
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["custom_text"] = "{name}",
						["text_face"] = "Continuum Medium",
						["anchor"] = {
							1, -- [1]
							2, -- [2]
						},
						["enabled"] = true,
						["enable_custom_text"] = false,
						["text_size"] = 11,
					},
					["auto_hide_menu"] = {
						["left"] = false,
						["right"] = false,
					},
					["switch_damager"] = false,
					["hide_in_combat"] = false,
					["posicao"] = {
						["normal"] = {
							["y"] = -382.5001983642578,
							["x"] = 662,
							["w"] = 200.0000610351563,
							["h"] = 165.0000152587891,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["skin_custom"] = "",
					["ignore_mass_showhide"] = false,
					["wallpaper"] = {
						["enabled"] = false,
						["width"] = 266,
						["texcoord"] = {
							0.048000001907349, -- [1]
							0.29800001144409, -- [2]
							0.63099998474121, -- [3]
							0.75599998474121, -- [4]
						},
						["overlay"] = {
							0.99999779462814, -- [1]
							0.99999779462814, -- [2]
							0.99999779462814, -- [3]
							0.79999822378159, -- [4]
						},
						["anchor"] = "all",
						["height"] = 226.00001525879,
						["alpha"] = 0.80000007152557,
						["texture"] = "Interface\\AddOns\\Details\\images\\skins\\darktheme",
					},
					["total_bar"] = {
						["enabled"] = false,
						["only_in_group"] = true,
						["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
						["color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["show_sidebars"] = false,
					["fontstrings_text3_anchor"] = 40,
					["use_multi_fontstrings"] = true,
					["menu_icons_size"] = 1,
				}, -- [1]
				{
					["__pos"] = {
						["normal"] = {
							["y"] = -360,
							["x"] = 860,
							["w"] = 200,
							["h"] = 165,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["hide_in_combat_type"] = 1,
					["clickthrough_window"] = false,
					["menu_anchor"] = {
						19, -- [1]
						1, -- [2]
						["side"] = 2,
					},
					["bg_r"] = 0,
					["hide_out_of_combat"] = false,
					["color_buttons"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons",
					["micro_displays_locked"] = true,
					["fontstrings_width"] = 35,
					["tooltip"] = {
						["n_abilities"] = 3,
						["n_enemies"] = 3,
					},
					["switch_all_roles_in_combat"] = false,
					["clickthrough_toolbaricons"] = false,
					["row_info"] = {
						["textR_outline"] = false,
						["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal_alpha",
						["textL_outline"] = false,
						["textR_outline_small"] = true,
						["textL_outline_small"] = true,
						["textL_enable_custom_text"] = false,
						["fixed_text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["space"] = {
							["right"] = 0,
							["left"] = 0,
							["between"] = 1,
						},
						["texture_background_class_color"] = false,
						["textL_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["font_face_file"] = "Interface\\AddOns\\ElvUI\\Media\\Fonts\\ContinuumMedium.ttf",
						["backdrop"] = {
							["enabled"] = false,
							["texture"] = "Details BarBorder 2",
							["color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0, -- [4]
							},
							["size"] = 0.5,
						},
						["models"] = {
							["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
							["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
							["upper_alpha"] = 0.5,
							["lower_enabled"] = false,
							["lower_alpha"] = 0.1,
							["upper_enabled"] = false,
						},
						["textL_translit_text"] = false,
						["height"] = 19,
						["texture_file"] = "Interface\\AddOns\\ElvUI_KyaUI\\media\\Textures\\BuiOnePixel.tga",
						["texture_custom_file"] = "Interface\\",
						["font_size"] = 10,
						["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
						["icon_grayscale"] = false,
						["textL_custom_text"] = "{data1}. {data3}{data2}",
						["textR_bracket"] = "<",
						["textR_enable_custom_text"] = false,
						["textR_show_data"] = {
							true, -- [1]
							true, -- [2]
							false, -- [3]
						},
						["fixed_texture_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["textL_show_number"] = true,
						["texture_custom"] = "",
						["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
						["textR_custom_text"] = "{data1}. {data3}",
						["texture"] = "KyaOnePixel",
						["fixed_texture_background_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["texture_background_file"] = "Interface\\AddOns\\ElvUI_KyaUI\\media\\Textures\\BuiOnePixel.tga",
						["textL_class_colors"] = true,
						["textR_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["texture_background"] = "KyaOnePixel",
						["textR_class_colors"] = false,
						["alpha"] = 0.8,
						["no_icon"] = false,
						["icon_offset"] = {
							0, -- [1]
							0, -- [2]
						},
						["start_after_icon"] = true,
						["font_face"] = "Continuum Medium",
						["texture_class_colors"] = true,
						["percent_type"] = 1,
						["fast_ps_update"] = false,
						["textR_separator"] = "|",
						["use_spec_icons"] = true,
					},
					["switch_tank"] = false,
					["plugins_grow_direction"] = true,
					["menu_icons"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						false, -- [6]
						["space"] = 0,
						["shadow"] = false,
					},
					["desaturated_menu"] = false,
					["micro_displays_side"] = 2,
					["window_scale"] = 1,
					["hide_icon"] = false,
					["toolbar_side"] = 2,
					["bg_g"] = 0,
					["menu_icons_alpha"] = 0.5,
					["bg_b"] = 0,
					["switch_healer_in_combat"] = false,
					["color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["hide_on_context"] = {
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [1]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [2]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [3]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [4]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [5]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [6]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [7]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [8]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [9]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [10]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [11]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [12]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [13]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [14]
						{
							["enabled"] = false,
							["inverse"] = false,
							["value"] = 100,
						}, -- [15]
					},
					["skin"] = "Dark Theme",
					["following"] = {
						["enabled"] = false,
						["bar_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["switch_healer"] = false,
					["fontstrings_text2_anchor"] = 74,
					["__snapV"] = false,
					["__snapH"] = false,
					["StatusBarSaved"] = {
						["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
						["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
						["options"] = {
							["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
								["isHidden"] = false,
								["segmentType"] = 2,
								["textFace"] = "Oswald",
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textAlign"] = 3,
								["timeType"] = 1,
								["textSize"] = 9,
								["textYMod"] = 0,
							},
							["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
								["isHidden"] = false,
								["segmentType"] = 2,
								["textFace"] = "Oswald",
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textAlign"] = 1,
								["timeType"] = 1,
								["textSize"] = 9,
								["textYMod"] = 0,
							},
							["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
								["isHidden"] = false,
								["segmentType"] = 2,
								["textFace"] = "Oswald",
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textAlign"] = 2,
								["timeType"] = 1,
								["textSize"] = 9,
								["textYMod"] = 0,
							},
						},
						["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
					},
					["grab_on_top"] = false,
					["__was_opened"] = true,
					["instance_button_anchor"] = {
						-27, -- [1]
						1, -- [2]
					},
					["version"] = 3,
					["fontstrings_text4_anchor"] = 3,
					["__locked"] = true,
					["menu_alpha"] = {
						["enabled"] = false,
						["onenter"] = 1,
						["iconstoo"] = true,
						["ignorebars"] = false,
						["onleave"] = 1,
					},
					["switch_all_roles_after_wipe"] = false,
					["row_show_animation"] = {
						["anim"] = "Fade",
						["options"] = {
						},
					},
					["bars_inverted"] = false,
					["strata"] = "LOW",
					["clickthrough_incombatonly"] = true,
					["__snap"] = {
						1, -- [1]
					},
					["stretch_button_side"] = 1,
					["hide_in_combat_alpha"] = 0,
					["bars_sort_direction"] = 1,
					["show_statusbar"] = true,
					["libwindow"] = {
						["y"] = 74.9997329711914,
						["x"] = -1,
						["point"] = "BOTTOMRIGHT",
						["scale"] = 1,
					},
					["statusbar_info"] = {
						["alpha"] = 1,
						["overlay"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
					},
					["backdrop_texture"] = "None",
					["menu_anchor_down"] = {
						19, -- [1]
						-2, -- [2]
					},
					["bg_alpha"] = 0,
					["switch_tank_in_combat"] = false,
					["bars_grow_direction"] = 1,
					["switch_damager_in_combat"] = false,
					["icon_desaturated"] = false,
					["clickthrough_rows"] = false,
					["auto_current"] = true,
					["attribute_text"] = {
						["enabled"] = true,
						["shadow"] = false,
						["side"] = 1,
						["text_size"] = 11,
						["custom_text"] = "{name}",
						["text_face"] = "Continuum Medium",
						["anchor"] = {
							1, -- [1]
							2, -- [2]
						},
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["enable_custom_text"] = false,
						["show_timer"] = true,
					},
					["auto_hide_menu"] = {
						["left"] = false,
						["right"] = false,
					},
					["switch_damager"] = false,
					["hide_in_combat"] = false,
					["posicao"] = {
						["normal"] = {
							["y"] = -382.5001983642578,
							["x"] = 860.4998779296875,
							["w"] = 197.0000305175781,
							["h"] = 165.0000152587891,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["skin_custom"] = "",
					["ignore_mass_showhide"] = false,
					["wallpaper"] = {
						["enabled"] = false,
						["texture"] = "Interface\\AddOns\\Details\\images\\skins\\darktheme",
						["texcoord"] = {
							0.048000001907349, -- [1]
							0.29800001144409, -- [2]
							0.63099998474121, -- [3]
							0.75599998474121, -- [4]
						},
						["overlay"] = {
							0.99999779462814, -- [1]
							0.99999779462814, -- [2]
							0.99999779462814, -- [3]
							0.79999822378159, -- [4]
						},
						["anchor"] = "all",
						["height"] = 226.00001525879,
						["alpha"] = 0.80000007152557,
						["width"] = 266,
					},
					["total_bar"] = {
						["enabled"] = false,
						["only_in_group"] = true,
						["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
						["color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["show_sidebars"] = false,
					["fontstrings_text3_anchor"] = 40,
					["use_multi_fontstrings"] = true,
					["menu_icons_size"] = 1,
				}, -- [2]
			},
			["report_lines"] = 5,
			["clear_ungrouped"] = true,
			["use_battleground_server_parser"] = false,
			["skin"] = "Dark Theme",
			["override_spellids"] = true,
			["use_scroll"] = false,
			["report_schema"] = 1,
			["overall_clear_newboss"] = true,
			["minimum_combat_time"] = 5,
			["overall_clear_logout"] = false,
			["new_window_size"] = {
				["height"] = 158,
				["width"] = 310,
			},
			["cloud_capture"] = true,
			["damage_taken_everything"] = false,
			["scroll_speed"] = 2,
			["font_sizes"] = {
				["menus"] = 10,
			},
			["memory_threshold"] = 3,
			["deadlog_events"] = 32,
			["window_clamp"] = {
				-8, -- [1]
				0, -- [2]
				21, -- [3]
				-14, -- [4]
			},
			["close_shields"] = false,
			["class_coords"] = {
				["HUNTER"] = {
					0, -- [1]
					0.25, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["WARRIOR"] = {
					0, -- [1]
					0.25, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["ROGUE"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["MAGE"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["PET"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["DRUID"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["MONK"] = {
					0.5, -- [1]
					0.73828125, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["DEATHKNIGHT"] = {
					0.25, -- [1]
					0.5, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["ENEMY"] = {
					0, -- [1]
					0.25, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["UNKNOW"] = {
					0.5, -- [1]
					0.75, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["PRIEST"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["UNGROUPPLAYER"] = {
					0.5, -- [1]
					0.75, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["Alliance"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["WARLOCK"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["DEMONHUNTER"] = {
					0.73828126, -- [1]
					1, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["Horde"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["PALADIN"] = {
					0, -- [1]
					0.25, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["SHAMAN"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["MONSTER"] = {
					0, -- [1]
					0.25, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
			},
			["windows_fade_out"] = {
				"out", -- [1]
				0.2, -- [2]
			},
			["disable_alldisplays_window"] = false,
			["standard_skin"] = false,
			["total_abbreviation"] = 2,
			["class_colors"] = {
				["HUNTER"] = {
					0.67, -- [1]
					0.83, -- [2]
					0.45, -- [3]
				},
				["WARRIOR"] = {
					0.78, -- [1]
					0.61, -- [2]
					0.43, -- [3]
				},
				["PALADIN"] = {
					0.96, -- [1]
					0.55, -- [2]
					0.73, -- [3]
				},
				["MAGE"] = {
					0.41, -- [1]
					0.8, -- [2]
					0.94, -- [3]
				},
				["ARENA_YELLOW"] = {
					1, -- [1]
					1, -- [2]
					0.25, -- [3]
				},
				["UNGROUPPLAYER"] = {
					0.4, -- [1]
					0.4, -- [2]
					0.4, -- [3]
				},
				["DRUID"] = {
					1, -- [1]
					0.49, -- [2]
					0.04, -- [3]
				},
				["MONK"] = {
					0, -- [1]
					1, -- [2]
					0.59, -- [3]
				},
				["DEATHKNIGHT"] = {
					0.77, -- [1]
					0.12, -- [2]
					0.23, -- [3]
				},
				["WARLOCK"] = {
					0.58, -- [1]
					0.51, -- [2]
					0.79, -- [3]
				},
				["UNKNOW"] = {
					0.2, -- [1]
					0.2, -- [2]
					0.2, -- [3]
				},
				["PRIEST"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["ROGUE"] = {
					1, -- [1]
					0.96, -- [2]
					0.41, -- [3]
				},
				["PET"] = {
					0.3, -- [1]
					0.4, -- [2]
					0.5, -- [3]
				},
				["ENEMY"] = {
					0.94117, -- [1]
					0, -- [2]
					0.0196, -- [3]
					1, -- [4]
				},
				["DEMONHUNTER"] = {
					0.64, -- [1]
					0.19, -- [2]
					0.79, -- [3]
				},
				["version"] = 1,
				["NEUTRAL"] = {
					1, -- [1]
					1, -- [2]
					0, -- [3]
				},
				["SHAMAN"] = {
					0, -- [1]
					0.44, -- [2]
					0.87, -- [3]
				},
				["ARENA_GREEN"] = {
					0.4, -- [1]
					1, -- [2]
					0.4, -- [3]
				},
			},
			["segments_auto_erase"] = 1,
			["clear_graphic"] = true,
			["trash_auto_remove"] = true,
			["animation_speed_triggertravel"] = 5,
			["options_group_edit"] = true,
			["segments_amount_to_save"] = 18,
			["minimap"] = {
				["onclick_what_todo"] = 1,
				["radius"] = 160,
				["hide"] = false,
				["minimapPos"] = 220,
				["text_format"] = 3,
				["text_type"] = 1,
			},
			["instances_amount"] = 5,
			["max_window_size"] = {
				["height"] = _G.RightChatDataPanel:GetHeight(),
				["width"] = _G.RightChatDataPanel:GetWidth(),
			},
			["deny_score_messages"] = false,
			["only_pvp_frags"] = false,
			["disable_stretch_button"] = true,
			["default_bg_color"] = 0.0941,
			["broadcaster_enabled"] = false,
			["hotcorner_topleft"] = {
				["hide"] = false,
			},
			["segments_panic_mode"] = false,
			["numerical_system_symbols"] = "auto",
			["overall_flag"] = 16,
			["row_fade_out"] = {
				"out", -- [1]
				0.2, -- [2]
			},
			["chat_tab_embed"] = {
				["enabled"] = false,
				["y_offset"] = 0,
				["x_offset"] = 0,
				["tab_name"] = "",
				["single_window"] = false,
			},
			["player_details_window"] = {
				["scale"] = 1,
				["skin"] = "ElvUI",
				["bar_texture"] = "Skyline",
			},
			["numerical_system"] = 1,
			["force_activity_time_pvp"] = true,
			["pvp_as_group"] = true,
			["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
			["disable_reset_button"] = false,
			["animate_scroll"] = false,
			["death_tooltip_width"] = 350,
			["time_type"] = 2,
			["default_bg_alpha"] = 0.5,
			["time_type_original"] = 2,
		}
		_detalhes:ApplyProfile(key)

		if KYA.isInstallerRunning == false then -- don't print during Install, when applying profile that doesn't exist
			KYA:Print(format(KYA.profileStrings[1], L['Details']))
		end
	else
		KYA:Print(format(KYA.profileStrings[2], L['Details']))
	end
end