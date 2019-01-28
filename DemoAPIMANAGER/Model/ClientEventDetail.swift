
//
//  File.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 24/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation

class ClientEventDetail: Codable {
    var data:[EventDetails]
}

struct EventDetails: Codable {
    var event_entity_id:String
    var event_encrypt_id: String
    var event_client_entity_id: String
    var event_title: String
    var event_start_screen_type: String
    var event_start_screen_background_image: String
    var event_logo_status: String
    var event_logo_image: String
    var event_logo_position: String
    var event_text_color: String
    var event_background_color: String
    var event_chroma_key_status: String
    var event_chroma_color: String
    var event_chroma_key_image: String
    var event_camera_type: String
    var event_counter_timer: String
    var event_suggested_hastages: String
    var event_email_status: String
    var event_subject: String
    var event_body: String
    var event_sms_status: String
    var event_sms_message_body: String
    var event_whatsapp_status: String
    var event_whatsapp_message_body: String
    var event_save_to_camera_roll: String
    var event_upload_to_vsnap: String
    var event_gallery_privacy_status: String
    var event_data_capture_status: String
    var event_data_capture_title: String
    var event_data_capture_text: String
    var event_data_capture_email_status: String
    var event_data_capture_phone_number_status: String
    var event_data_capture_firstname_status: String
    var event_data_capture_lastname_status: String
    var event_data_capture_custom_terms_and_privacy_status: String
    var event_data_capture_custom_terms_and_privacy_message: String
    var event_view_counts: String
    var event_create_date: String
    var event_update_date: String
    var event_archive: String
    var event_status: String
    var scenes_data:[Scene]
}

struct Scene: Codable {
    var scene_entity_id: String
    var scene_encrypt_id: String
    var scene_client_entity_id: String
    var scene_event_entity_id: String
    var scene_frames: String
    var scene_name: String
    var scene_type: String
    var scene_length: String
    var scene_overlay_image: String
    var scene_overlay_video: String
    var scene_start_delay: String
    var scene_status: String
    var scene_record_audio_status: String
    var scene_background_image: String
    var scene_background_video: String
    var scene_instruction_text: String
    var scene_countdown_length: String
}

