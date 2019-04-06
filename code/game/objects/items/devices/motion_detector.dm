
#define MOTION_DETECTOR_LONG	0
#define MOTION_DETECTOR_SHORT	1


/obj/effect/detector_blip
	icon = 'icons/Marine/marine-items.dmi'
	icon_state = "detector_blip"
	layer = BELOW_FULLSCREEN_LAYER

	Dispose()
		..()
		return TA_REVIVE_ME

/obj/item/device/motiondetector
	name = "motion detector"
	desc = "A device that detects movement, but ignores marines. It has a mode selection button on the side."
	icon = 'icons/Marine/marine-items.dmi'
	icon_state = "detector"
	item_state = "electronic"
	flags_atom = FPRINT| CONDUCT
	flags_equip_slot = SLOT_WAIST
	var/list/blip_pool = list()
	var/detector_range = 14
	var/detector_mode = MOTION_DETECTOR_LONG
	w_class = 3
	var/active = 0
	var/recycletime = 120
	var/long_range_cooldown = 2
	var/blip_type = "detector"
	actions_types = list(/datum/action/item_action)

/obj/item/device/motiondetector/verb/toggle_range_mode()
	set name = "Toggle Range Mode"
	set category = "Object"
	detector_mode = !detector_mode
	if(detector_mode)
		usr << "<span class='notice'>You switch [src] to short range mode.</span>"
		detector_range = 7
	else
		usr << "<span class='notice'>You switch [src] to long range mode.</span>"
		detector_range = 14
	if(active)
		icon_state = "[initial(icon_state)]_on_[detector_mode]"


/obj/item/device/motiondetector/attack_self(mob/user)
	if(ishuman(user))
		active = !active
		if(active)
			icon_state = "[initial(icon_state)]_on_[detector_mode]"
			user << "<span class='notice'>You activate [src].</span>"
			processing_objects.Add(src)

		else
			icon_state = "[initial(icon_state)]"
			user << "<span class='notice'>You deactivate [src].</span>"
			processing_objects.Remove(src)

/obj/item/device/motiondetector/Dispose()
	processing_objects.Remove(src)
	for(var/obj/X in blip_pool)
		qdel(X)
	blip_pool = list()
	..()

/obj/item/device/motiondetector/process()
	if(!active)
		processing_objects.Remove(src)
		return
	recycletime--
	if(!recycletime)
		recycletime = initial(recycletime)
		for(var/X in blip_pool) //we dump and remake the blip pool every few minutes
			if(blip_pool[X])	//to clear blips assigned to mobs that are long gone.
				qdel(blip_pool[X])
		blip_pool = list()

	if(!detector_mode)
		long_range_cooldown--
		if(long_range_cooldown) return
		else long_range_cooldown = initial(long_range_cooldown)

	playsound(loc, 'sound/items/detector.ogg', 60, 0, 7, 2)
	scan()

/obj/item/device/motiondetector/proc/scan()
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	for(var/mob/M in living_mob_list)
		var/detected

		if(loc == null || M == null) continue
		if(loc.z != M.z) continue
		if(get_dist(M, src) > detector_range) continue
		if(M == loc) continue //device user isn't detected
		if(!isturf(M.loc)) continue
		if(world.time > M.l_move_time + 20) continue //hasn't moved recently
		if(isrobot(M)) continue
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.wear_ear, /obj/item/device/radio/headset/almayer))
				continue //device detects marine headset and ignores the wearer.
		detected = TRUE

		if(human_user)
			show_blip(human_user, M)

		if(detected)
			playsound(loc, 'sound/items/tick.ogg', 50, 0, 7, 2)

/obj/item/device/motiondetector/proc/show_blip(mob/user, mob/target)
	set waitfor = 0
	if(user.client)

		if(!blip_pool[target])
			blip_pool[target] = new /obj/effect/detector_blip

		var/obj/effect/detector_blip/DB = blip_pool[target]
		var/c_view = user.client.view
		var/view_x_offset = 0
		var/view_y_offset = 0
		if(c_view > 7)
			if(user.client.pixel_x >= 0) view_x_offset = round(user.client.pixel_x/32)
			else view_x_offset = Ceiling(user.client.pixel_x/32)
			if(user.client.pixel_y >= 0) view_y_offset = round(user.client.pixel_y/32)
			else view_y_offset = Ceiling(user.client.pixel_y/32)

		var/diff_dir_x = 0
		var/diff_dir_y = 0
		if(target.x - user.x > c_view + view_x_offset) diff_dir_x = 4
		else if(target.x - user.x < -c_view + view_x_offset) diff_dir_x = 8
		if(target.y - user.y > c_view + view_y_offset) diff_dir_y = 1
		else if(target.y - user.y < -c_view + view_y_offset) diff_dir_y = 2
		if(diff_dir_x || diff_dir_y)
			DB.icon_state = "[blip_type]_blip_dir"
			DB.dir = diff_dir_x + diff_dir_y
		else
			DB.icon_state = "[blip_type]_blip"
			DB.dir = initial(DB.dir)

		DB.screen_loc = "[Clamp(c_view + 1 - view_x_offset + (target.x - user.x), 1, 2*c_view+1)],[Clamp(c_view + 1 - view_y_offset + (target.y - user.y), 1, 2*c_view+1)]"
		user.client.screen += DB
		sleep(12)
		if(user.client)
			user.client.screen -= DB

/obj/item/device/motiondetector/intel
	name = "data detector"
	desc = "A device that detects objects that may be useful for intel gathering. It has a mode selection button on the side."
	icon_state = "datadetector"
	blip_type = "data"
	var/objects_to_detect = list(/obj/item/document_objective, /obj/item/disk/objective, /obj/item/device/mass_spectrometer/adv/objective, /obj/item/device/reagent_scanner/adv/objective, /obj/item/device/healthanalyzer/objective, /obj/item/device/autopsy_scanner/objective, /obj/item/device/autopsy_scanner/objective)

/obj/item/device/motiondetector/intel/scan()
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	for(var/obj/I in orange(detector_range, loc))
		var/detected
		for(var/DT in objects_to_detect)
			if(istype(I, DT))
				detected = TRUE
			if(I.contents)
				for(var/obj/item/CI in I.contents)
					if(istype(CI, DT))
						detected = TRUE
						break
			if(human_user && detected)
				show_blip(human_user, I)
			if(detected)
				break

		if(detected)
			playsound(loc, 'sound/items/tick.ogg', 50, 0, 7, 2)

	for(var/mob/M in orange(detector_range, loc))
		var/detected
		if(loc == null || M == null) continue
		if(loc.z != M.z) continue
		if(M == loc) continue //device user isn't detected
		if((isXeno(M) || isYautja(M)) && M.stat == DEAD )
			detected = TRUE

			if(human_user)
				show_blip(human_user, M)
		if(ishuman(M) && M.stat == DEAD && M.contents)
			for(var/obj/I in M.contents)
				for(var/DT in objects_to_detect)
					if(istype(I, DT))
						detected = TRUE
						break
					else if(I.contents)
						for(var/obj/CI in I.contents)
							if(istype(CI, DT))
								detected = TRUE
								break
			if(detected)
				show_blip(human_user, M)
		if(detected)
			playsound(loc, 'sound/items/tick.ogg', 50, 0, 7, 2)