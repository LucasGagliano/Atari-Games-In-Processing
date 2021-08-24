import ProcessingEngine.*;

Input Input;
Collider Collider;

Jogo Jogo;
Player Player;
Bola Bola;
Bloco Bloco;

Bloco[] blocos;

PFont breakoutFont;

void setup()
{
  size(800, 600);
  
  Input = new Input();
  Collider = new Collider();
  
  Jogo = new Jogo();
  Player = new Player();
  Bola = new Bola();
  Bloco = new Bloco();
  
  breakoutFont = createFont("BreakoutFont.ttf", 30);

  Jogo.indexFase = 0;
  Jogo.duracaoAnimacao = 1;
  Jogo.estaFazendoAnimacao = true;
  
  Player.vidas = 3;
  
  Player.largura = 100;
  Player.altura = 15;
  Player.posicaoAtualX = 0;
  Player.posicaoAtualY = 0;
  Player.forcaMovimentoHorizontal = 6;
  
  Player.keyLeft = new char[2];
  Player.keyLeft[0] = 'd';
  Player.keyLeft[1] = 'D';
  
  Player.keyRight = new char[2];
  Player.keyRight[0] = 'a';
  Player.keyRight[1] = 'A';
  Player.isKeyLeft = false;
  Player.isKeyRight = false;
  
  Bola.largura = 10;
  Bola.altura = 10;
  Bola.posicaoAtualX = 0;
  Bola.posicaoAtualY = 0;
  Bola.forcaMovimentoHorizontal = 3.65;
  Bola.forcaMovimentoVertical = 3;
  Bola.direcaoHorizontal = 1;
  Bola.direcaoVertical = -1;
  
  Bloco.numeroFileiras = 12;
  Bloco.numeroBlocosPorFileira = 8;
  Bloco.corAtual = 0;
  
  Jogo.contadorBlocosFase = Bloco.numeroFileiras * Bloco.numeroBlocosPorFileira - Bloco.numeroBlocosPorFileira;
  
  Bloco.coresBlocos = new color[Bloco.numeroFileiras * Bloco.numeroBlocosPorFileira];
  blocos = new Bloco[Bloco.numeroFileiras * Bloco.numeroBlocosPorFileira];
  Bloco.isBlocos = new Boolean[Bloco.numeroFileiras * Bloco.numeroBlocosPorFileira];
  
  Player.Spawnar(width / 2 - Player.largura / 2, height - height / 10 - Player.altura / 2);
  
  Bola.estaSpawnada = true;
  Bola.Spawnar(width / 2 - Bola.largura / 2, height / 2 + height / 4 - Bola.altura / 2);
  
  for (int x = 0; x < Bloco.coresBlocos.length; x++)
  {
    Bloco.coresBlocos[x] = color(random(125, 255), random(125, 255), random(125, 255));
    Bloco.isBlocos[x] = false;
  }
}
void draw()
{
  Jogo.DesenharFaseAtual();
}
void keyPressed()
{
  if(key == Player.keyRight[0] || key == Player.keyRight[1])
    Player.isKeyRight = true;
  if(key == Player.keyLeft[0] || key == Player.keyLeft[1])
    Player.isKeyLeft = true;
}
void keyReleased()
{
  if(key == Player.keyRight[0] || key == Player.keyRight[1])
    Player.isKeyRight = false;
  if(key == Player.keyLeft[0] || key == Player.keyLeft[1])
    Player.isKeyLeft = false;
}

class Jogo
{
  int indexFase, contadorBlocosFase;
  float duracaoAnimacao;
  boolean estaFazendoAnimacao;
  
  void DesenharFaseAtual()
  {
    background(0);
    
    if(indexFase == 0)
      Menu(indexFase);
    else if(indexFase == 1)
      LevelUm();
  }
  
  void Menu(int index)
  {
    switch (index)
    {
      case 0:
        if(estaFazendoAnimacao && duracaoAnimacao != 0)
        {
            textSize(13.5);
            if(duracaoAnimacao < 255)
            {
              fill(255, 255, 255, duracaoAnimacao - 30);
              text("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'BREAKOUT', DA ATARI INC., DE 1972,  E FORA", width / 2 - textWidth("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'BREAKOUT', DA ATARI INC., DE 1972,  E FORA") / 2, height / 2 - textAscent() / 2);
              text("DESENVOLVIDO USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE'", width / 2 - textWidth("DESENVOLVIDO USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE'") / 2, height / 2 + textAscent() / 2);
              text("SEM POSSUIR QUAISQUER FINS LUCRATIVOS", width / 2 - textWidth("SEM POSSUIR QUAISQUER FINS LUCRATIVOS") / 2, height / 2 + (textAscent() / 2) * 2.95);
              duracaoAnimacao += 0.85;
            }
            else if(duracaoAnimacao < 510)
            {
              fill(255, 255, 255, (255 - (duracaoAnimacao - 255)) - 30);
              text("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'BREAKOUT', DA ATARI INC., DE 1972,  E FORA", width / 2 - textWidth("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'BREAKOUT', DA ATARI INC., DE 1972,  E FORA") / 2, height / 2 - textAscent() / 2);
              text("DESENVOLVIDO USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE'", width / 2 - textWidth("DESENVOLVIDO USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE'") / 2, height / 2 + textAscent() / 2);
              text("SEM POSSUIR QUAISQUER FINS LUCRATIVOS", width / 2 - textWidth("SEM POSSUIR QUAISQUER FINS LUCRATIVOS") / 2, height / 2 + (textAscent() / 2) * 2.95);
              duracaoAnimacao += 0.85;
            }
            else
              duracaoAnimacao = 0;
        }
        else
        {
          estaFazendoAnimacao = false;
          indexFase += 1;
        }
        break;
    }
  }
  
  void LevelUm()
  {   
    fill(255);
    rect(25, 25, 10, 10);
    text("x" + Player.vidas, 25 + textWidth("x" + Player.vidas), 25 + textAscent() / 2 + 2.5);
    
    
    for (int x = 0; x < Bloco.numeroFileiras; x++)
    {
      for (int i = 0; i < Bloco.numeroBlocosPorFileira; i++)
      {
        if(x == 0)
        {
          blocos[i] = new Bloco();
          
          if(Collider.IsRectColliding(Bola.posicaoAtualX, 102.5 + i * (width - 200) / Bloco.numeroBlocosPorFileira, Bola.posicaoAtualY, 50 + 22.5, Bola.largura, (width - 200) / Bloco.numeroBlocosPorFileira, Bola.altura, 20) && Bloco.isBlocos[Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)] == false)
          {
            Bola.direcaoVertical = -Bola.direcaoVertical;
            Bloco.isBlocos[Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)] = true;
            Jogo.contadorBlocosFase -= 1;
          }
          
          blocos[Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)] = new Bloco();
          fill(Bloco.coresBlocos[i]);
          
          if(!Bloco.isBlocos[Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)])
            blocos[Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)].DesenharBloco(102.5 + i * (width - 200) / Bloco.numeroBlocosPorFileira, 50 + 22.5, (width - 200) / Bloco.numeroBlocosPorFileira, 20);
        }
        else
        {        
          blocos[x * i] = new Bloco();
          
          if(Collider.IsRectColliding(Bola.posicaoAtualX, 102.5 + i * (width - 200) / Bloco.numeroBlocosPorFileira, Bola.posicaoAtualY, 50 + (x * 22.5), Bola.largura, (width - 200) / Bloco.numeroBlocosPorFileira, Bola.altura, 20) && Bloco.isBlocos[x * Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)] == false)
          {
            Bola.direcaoVertical = -Bola.direcaoVertical;
            Bloco.isBlocos[x * Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)] = true;
            Jogo.contadorBlocosFase -= 1;
          }
          
          blocos[x * Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)] = new Bloco();
          
          fill(Bloco.coresBlocos[i + Bloco.numeroBlocosPorFileira * x]);
          
          if(!Bloco.isBlocos[x * Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)])
            blocos[x * Bloco.numeroBlocosPorFileira - (Bloco.numeroBlocosPorFileira - i)].DesenharBloco(102.5 + i * (width - 200) / Bloco.numeroBlocosPorFileira, 50 + (x * 22.5), (width - 200) / Bloco.numeroBlocosPorFileira, 20);
        }
        
        Bloco.corAtual++;
        
        if(Bloco.corAtual == Bloco.coresBlocos.length - 1)
          Bloco.corAtual = 0;
      }
    }
    
    Player.Colidir();
    Bola.Colidir();
    
    Player.Mover();
    Bola.Mover();
  }
}

class Player
{
  int vidas;
  float largura, altura, posicaoAtualX, posicaoAtualY, forcaMovimentoHorizontal;
  char[] keyLeft, keyRight;
  boolean isKeyLeft, isKeyRight;
  
  void Spawnar(float posicaoInicialX, float posicaoInicialY)
  {
    posicaoAtualX = posicaoInicialX;
    posicaoAtualY = posicaoInicialY;
  }
  
  void Mover()
  {
    float h = 0;
    
    if(Bola.estaSpawnada)
      h = Input.GetAxis("Horizontal", isKeyRight, isKeyLeft);

    posicaoAtualX += forcaMovimentoHorizontal * h;
    
    fill(255);
    rect(posicaoAtualX, posicaoAtualY, largura, altura);
  }
  
  void Colidir()
  {
    if(Collider.IsRectColliding(posicaoAtualX, 0, posicaoAtualY, 0, largura, 0, altura, height))
      posicaoAtualX = 0;
    
    else if(Collider.IsRectColliding(posicaoAtualX, width, posicaoAtualY, 0, largura, 0, altura, height))
      posicaoAtualX = width - largura;
      
  }
}

class Bola
{
  float largura, altura, posicaoAtualX, posicaoAtualY, forcaMovimentoHorizontal, forcaMovimentoVertical, direcaoHorizontal, direcaoVertical;
  boolean estaSpawnada;
  
  void Spawnar(float posicaoInicialX, float posicaoInicialY)
  {
    posicaoAtualX = posicaoInicialX;
    posicaoAtualY = posicaoInicialY;
  }
  
  void Mover()
  {
    if(Jogo.contadorBlocosFase > 0)
    {
      posicaoAtualX += forcaMovimentoHorizontal * direcaoHorizontal;
      posicaoAtualY += forcaMovimentoVertical * direcaoVertical;
    }
    
    rect(posicaoAtualX, posicaoAtualY, largura, altura);
  }
  
  void Colidir()
  {
    if(Collider.IsRectColliding(posicaoAtualX, Player.posicaoAtualX, posicaoAtualY, Player.posicaoAtualY, largura, Player.largura, altura, Player.altura))
    {
      direcaoVertical = -1;
      
      if(Collider.IsRectColliding(posicaoAtualX, Player.posicaoAtualX, posicaoAtualY, Player.posicaoAtualY, largura, Player.largura / 2, altura, Player.altura))
        direcaoHorizontal = -1;
      else
        direcaoHorizontal = 1;
    }
    
    if(Collider.IsRectColliding(posicaoAtualX, 0, posicaoAtualY, 0, largura, width, altura, 0))
      direcaoVertical = 1;
      
    if(Collider.IsRectColliding(posicaoAtualX, 0, posicaoAtualY, 0, largura, 0, altura, height) || Collider.IsRectColliding(posicaoAtualX, width, posicaoAtualY, 0, largura, 0, altura, height))
      direcaoHorizontal = - direcaoHorizontal;
      
    if(Collider.IsRectColliding(posicaoAtualX, 0, posicaoAtualY, height, largura, width, altura, 0) && Player.vidas > 0)
    {
      Player.vidas--;
      estaSpawnada = false;
      
      if(Player.vidas > 0)
        Bola.Spawnar(Player.posicaoAtualX + Player.largura / 2, Player.posicaoAtualY - Bola.altura * 4.75);
        
      estaSpawnada = true;
    }
  }
}

class Bloco
{
  int numeroFileiras, numeroBlocosPorFileira, corAtual;
  Boolean[] isBlocos;
  color[] coresBlocos;
  
  void DesenharBloco(float posicaoX, float posicaoY, float largura, float altura)
  {
    rect(posicaoX, posicaoY, largura, altura);
  }
}
