class Bola extends Objeto
{
  private float h, forcaMovimentoHorizontal, a, b, c;
  
  public Bola()
  {
    largura = altura = 15;
    
    h = v = 1;
    forcaMovimentoHorizontal = forcaMovimentoVertical = 6.75;
    
    Centralizar();
  }
  
  public void Centralizar()
  {
    posX = width / 2 - largura / 2;
    posY = height / 2 - altura / 2;
  }
  
  public void AtualizarPosicao()
  {
    posX += forcaMovimentoHorizontal * h;
    posY += forcaMovimentoVertical * abs(sin(c)) * v;
  }
  
  public void Colidir()
  {
    if (posY <= 0 || posY >= height)
    {
      v = -v;
      
      pingFX.stop();
      pingFX.play();
    }
    
    for (int x = 0; x < j.length; x++)
    {
      if (Collider.IsRectColliding(posX, j[x].posX,posY, j[x].posY, largura, j[x].largura, altura, j[x].altura))
      {
        pingFX.stop();
        pingFX.play();
        
        h = -h;
        posX = posX < j[0].posX + j[0].largura ? j[0].posX + j[0].largura : posX > width - 35 - j[1].largura ? width - 35 - j[1].largura : posX;
        v = posY < j[x].posY + j[x].altura / 2 ? -1 : posY > j[x].posY + j[x].altura / 2 ? 1 : 0;
        a = posY - j[x].posY + j[x].altura / 2;
        b = a / (j[x].altura / 2);
        c = b * ((5 * PI / 12) * (180 / PI));
      }
    }
    
    for (int x = 0; x < pontos.length; x++)
      if ((x % 2 == 1 && posX <= 0) || (x % 2 == 0 && posX + largura >= width))
      {
        pontos[x] += 1;
        Centralizar();
      }
  }
  
  public void Mover()
  {
    rect(posX, posY, largura, altura);
  }
}
