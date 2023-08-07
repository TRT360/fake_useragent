# frozen_string_literal: true

require 'json'

SMARTPHONE_DEV_IDS = JSON.parse(
  File.read(File.join(File.dirname(File.absolute_path(__FILE__)), 'data/smartphone_dev_id.json'))
)
TABLET_DEV_IDS = JSON.parse(
  File.read(File.join(File.dirname(File.absolute_path(__FILE__)), 'data/tablet_dev_id.json'))
)
DESKTOP_USERAGENTS = JSON.parse(
  File.read(File.join(File.dirname(File.absolute_path(__FILE__)), 'data/desktop_useragents_list.json'))
)
MOBILE_USERAGENTS = JSON.parse(
  File.read(File.join(File.dirname(File.absolute_path(__FILE__)), 'data/mobile_useragents_list.json'))
)
