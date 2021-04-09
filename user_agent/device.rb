require 'json'

SMARTPHONE_DEV_IDS = JSON.parse(
  File.read(File.join(File.dirname(File.absolute_path(__FILE__)), 'data/smartphone_dev_id.json'))
)
TABLET_DEV_IDS = JSON.parse(
  File.read(File.join(File.dirname(File.absolute_path(__FILE__)), 'data/tablet_dev_id.json'))
)
