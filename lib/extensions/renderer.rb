class Renderer
  def render(resource)
    inner_method = resource.class.gsub(/(.)([A-Z])/,'\1_\2').downcase
    send("render_#{inner_method}")
  end

  protected
  def render_account
    raise NotImplementedError
  end

  def render_wallet
    raise NotImplementedError
  end
end
