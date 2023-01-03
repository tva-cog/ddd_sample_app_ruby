class Cargo
  attr_accessor :tracking_id, :route_specification, :itinerary, :delivery

  class InitializationError < RuntimeError; end

  def initialize(tracking_id, route_specification)
    raise InitializationError unless tracking_id && route_specification

    @tracking_id = tracking_id
    @route_specification = route_specification
    @delivery = Delivery.update_on_routing(@route_specification, @itinerary)
  end

  def specify_new_route(route_specification)
    raise ArgumentError, "Route specification cannot be nil" unless route_specification

    @route_specification = route_specification
    @delivery = Delivery.update_on_routing(@route_specification, @itinerary)
  end

  def assign_to_route(itinerary)
    raise ArgumentError, "Itinerary cannot be nil" unless itinerary

    @itinerary = itinerary
    @delivery = Delivery.update_on_routing(@route_specification, @itinerary)
  end

  def derive_delivery_progress(last_handling_event)
    @delivery = Delivery.derived_from(@route_specification, @itinerary, last_handling_event)
  end

  def ==(other)
    tracking_id == other.tracking_id
  end
end
