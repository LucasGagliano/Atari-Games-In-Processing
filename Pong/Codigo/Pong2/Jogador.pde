class Jogador extends Objeto
{
  public String tipoJogador;

  public Jogador(int x)
  {
    largura = 20;
    altura = 100;
    forcaMovimentoVertical = 6.5;
    
    posX = width * x + width / 64 - (x % 2 == 1 ? (width / 64 * 2 + largura) : 0);
    posY = random(altura, height - altura);
  }
  
  public void AtualizarPosicao(boolean teclaPositiva, boolean teclaNegativa)
  {
    v = Input.GetAxis(teclaPositiva, teclaNegativa);
    posY = posY < 0 ? 0 : posY + altura > height ? posY = height - altura : tipoJogador == "Player" ? !estaComMicrofone || estaMultiplayer ? posY + v * forcaMovimentoVertical : amp.analyze() > posicaoSliders[0] / 1000 ? posY - v : posY + v + v * amp.analyze() : tipoJogador == "AI" && (b.h == 1 || b.posX > width / 2) ? b.posY + b.altura < posY ? posY - forcaMovimentoVertical : b.posY > posY + altura ? posY + forcaMovimentoVertical : posY : posY;
  }
  
  public void Mover()
  {
    rect(posX, posY, largura, altura);
  }
}
