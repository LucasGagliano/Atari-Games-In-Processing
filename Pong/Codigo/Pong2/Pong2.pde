// Pong in Processing, made by Lucas Martin; //<>//
// Please, do not sell this code, since Pong! does not belongs to me, but to Atari;
// And please, do not redistribute this code without my authorization;
// Contact: lucasmartinmacedo@gmail.com;

// Libraries that are used on this project.
import template.library.*;
import processing.sound.*;

// References for the other classes that are used within the code.
public Amplitude amp;
public Input Input;
public Collider Collider;
private PApplet pa;
private AudioIn in;
private UI UI;
private Bola b;  
private Jogador j[];

// Theses variables need to be created in the main script. Which means, this script, duh.
public int levelIndex;
public int[] pontos;
public boolean estaMultiplayer, estaComAudio, estaComMicrofone;
public SoundFile pingFX; 
private int NUMERO_DE_PLAYERS, NUMERO_DE_PACOTES_DE_ICONES, NUMERO_DE_ICONES, numBotoes;
private float duracaoAnimacao;
private float[] posicaoSliders;
private boolean estaFazendoAnimacao, estaLoopandoMusica, estaComMenuAberto;
private boolean[] estaNoBotao, estaPressionandoTeclas[];
private char[] [] teclas = {{'W', 'S'}, {UP, DOWN}};
private String titulosBotoes[];
private PFont pingPongFont, basicFont;
private PImage[] [] icones;
private SoundFile musica;

// Below, are Processing's methods...
public void setup()
{
  size(1280, 732);
  pa = this;
  
  NUMERO_DE_PLAYERS = NUMERO_DE_PACOTES_DE_ICONES = NUMERO_DE_ICONES = 2;
  
  in = new AudioIn(this, 1);
  amp = new Amplitude(this);
  Input = new Input();
  Collider = new Collider(); 
  UI = new UI(); 
  b = new Bola();
  j = new Jogador[NUMERO_DE_PLAYERS];
  
  pingPongFont = createFont("PingPongFont.ttf", 32);
  basicFont = createFont("Coolvetica.ttf", 32); textFont(basicFont);
  
  pingFX = new SoundFile(this, "pingFX.aiff");
  musica = new SoundFile(this, "soundtrack.aiff");
  
  in.start(0);
  amp.input(in);
  
  duracaoAnimacao = 1;
  levelIndex = 0;
  
  estaComAudio = estaFazendoAnimacao = true;
  estaComMicrofone = estaLoopandoMusica = false;
  
  pontos = new int[NUMERO_DE_PLAYERS];
  posicaoSliders = new float[1];
  icones = new PImage[NUMERO_DE_PACOTES_DE_ICONES][]; 
  estaPressionandoTeclas = new boolean[teclas.length][];
  
  for (int x = 0; x < NUMERO_DE_PACOTES_DE_ICONES; x++)
    icones[x] = new PImage[NUMERO_DE_ICONES];
    
  for (int x = 0; x < NUMERO_DE_PACOTES_DE_ICONES; x++)
    for (int y = 0; y < NUMERO_DE_ICONES; y++)
      icones[x][y] = loadImage("icone" + x + "_" + y + ".png");
      
  for (int x = 0; x < teclas.length; x++)
    estaPressionandoTeclas[x] = new boolean[teclas[x].length];

  for(int x = 0; x < j.length; x++)
    j[x] = new Jogador(x);
}
public void draw()
{
  background(0); 
  stroke(255); 
  fill(255);
  
  Niveis(levelIndex);
}
public void keyPressed()
{
  if(estaFazendoAnimacao) return;
  
  for (int x = 0; x < teclas.length; x++)
    for (int y = 0; y < teclas[x].length; y++)
      if (key == teclas[x][y] || keyCode == teclas[x][y])
        estaPressionandoTeclas[x][y] = true;
      
  if(key != 27) return;
  key = 0;
  estaComMenuAberto = levelIndex == 6 ? !estaComMenuAberto : estaComMenuAberto;
}
public void keyReleased()
{
  if(estaFazendoAnimacao) return;
  
  for (int x = 0; x < teclas.length; x++)
    for (int y = 0; y < teclas[x].length; y++)
      if (key == teclas[x][y] || keyCode == teclas[x][y])
        estaPressionandoTeclas[x][y] = false;
}
public void mousePressed()
{
  if (estaFazendoAnimacao && levelIndex == 1 && duracaoAnimacao < height - 150)
    estaFazendoAnimacao = false;
  else if (!estaFazendoAnimacao)
    for (int x = 0; x < estaNoBotao.length; x++)
      if(estaNoBotao[x] && (levelIndex != 6 || (levelIndex == 6 && estaComMenuAberto)))
        AcoesBotoes(x);
}

// ...and here, begins my own methods.
private void Niveis(int levelIndex)
{
  switch(levelIndex)
  {
    case 0: case 1: case 2: case 3: case 4: case 5:
      Menu(levelIndex);
      break;
        
    case 6:
      NivelUm();
      break;
      
    case 7:
      GameOver();
      break;
  }

  if (estaFazendoAnimacao || levelIndex == 0) return;
  
  if(!estaComAudio)
  {
    estaLoopandoMusica = false;
    musica.stop();
  }
  else if (!estaLoopandoMusica)
  {
    estaLoopandoMusica = true;
    musica.loop(1, 0.05);
  }
}

private void Menu(int parteMenu)
{
  estaComMenuAberto = false;
  
  switch(parteMenu)
  {
    case 0:
      if (!estaFazendoAnimacao)
      {
         duracaoAnimacao = height + 175;
         levelIndex = 1;
         estaFazendoAnimacao = true;
         textFont(pingPongFont);
      }
      else if (duracaoAnimacao != 0)
      {
        textSize(20);
        fill(255, 255, 255, duracaoAnimacao < 255 ? duracaoAnimacao - 30 : (255 - (duracaoAnimacao - 255)) - 30);
        text("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'PONG', DA ATARI INC., DE 1972,  E FORA DESENVOLVIDO", width / 2 - textWidth("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'PONG', DA ATARI INC., DE 1972,  E FORA DESENVOLVIDO'.") / 2, height / 2 - textAscent() / 2);
        text("USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE', SEM", width / 2 - textWidth("USANDO A LINGUAGEM DE PROGRAMAÇÂO PROCESSING E SUA 'LANGUAGE REFERENCE', SEM") / 2, height / 2 + textAscent() / 2);
        text("POSSUIR QUAISQUER FINS LUCRATIVOS", width / 2 - textWidth("POSSUIR QUAISQUER FINS LUCRATIVOS") / 2, height / 2 + (textAscent() / 2) * 2.95);
        duracaoAnimacao = duracaoAnimacao < 510 ? duracaoAnimacao + 0.85 : 0;
      }
      else
        estaFazendoAnimacao = false;
      break;
      
    case 1:
      textSize(196);
      
      if (!estaFazendoAnimacao)
      {
        numBotoes = 4;
        estaNoBotao = new boolean[numBotoes];
        titulosBotoes = new String[]{"COMEÇAR", "CONFIGURAÇÕES", "CRÉDITOS", "SAIR"};
        text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        
        UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
        
        for (int x = 0; x < numBotoes; x++)
        {
          estaNoBotao[x] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75), titulosBotoes[x], 55);
          fill(255);
          square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75) - textAscent() / 2 + 7.5, 15);
        }

      }
      else if (duracaoAnimacao >= height / 30 - 75)
      {
        text("PONG", width / 2 - textWidth("PONG") / 2, height + textAscent() - (height - duracaoAnimacao));
        duracaoAnimacao -= 2.15;
      }
      else
        estaFazendoAnimacao = false;
      break;
      
    case 2:
      textSize(196);
      
      numBotoes = 3;
      estaNoBotao = new boolean[3];
      text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        
      textSize(45);
      estaNoBotao[0] = UI.CriarBotoes(pa, 'i', estaComAudio ? icones[0][0] : icones[0][1], width - width / 13, height - (height / 16) - 50, 50, 50);
      estaNoBotao[1] = UI.CriarBotoes(pa, 'i', estaComMicrofone ? icones[1][0] : icones[1][1], width - width / 4 + width / 32, height / 2, 50, 50);
      estaNoBotao[2] = UI.CriarBotoes(pa, 't', width / 13, height - (height / 16), "VOLTAR", 55);
      posicaoSliders[0] = UI.CriarSlider(pa, width - width / 4 + width / 64, height / 2 + height / 16 * 2, 100);
      
      fill(255);
      text("On / Off", width / 2 + width / 16, height / 2 + textAscent() / 2); 
      text("Microfone", width - width / 4 - width / 256, height / 2 - height / 16);
      text("Sensibilidade", width / 2 + width / 16, height / 2 + height / 16 * 2 + textAscent() / 2);
      text("Controles", width / 2 - width / 4 + width / 128, height / 2 - height / 16);
      text("P1", width / 2 - width / 4, height / 2 + textAscent() / 2);
      text("P2", width / 2 - width / 4 + width / 10, height / 2 + textAscent() / 2);
      text("Cima", width / 2 - width / 4 - width / 8, height / 2 + height / 16 * 2 + textAscent() / 2);
      text("Baixo", width / 2 - width / 4 - width / 8, height / 2 + height / 8 * 2 + textAscent() / 2);
      text("W", width / 2 - width / 4, height / 2 + height / 16 * 2 + textAscent() / 2);
      text("S", width / 2 - width / 4, height / 2 + height / 8 * 2 + textAscent() / 2);
      text("UP", width / 2 - width / 4 + width / 10, height / 2 + height / 16 * 2 + textAscent() / 2);
      text("DOWN", width / 2 - width / 4 + width / 10, height / 2 + height / 8 * 2 + textAscent() / 2);
      break;
      
    case 3:
      textSize(196);
      
      numBotoes = 1;
      estaNoBotao = new boolean[numBotoes];
      text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
      estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 13, height - (height / 16), "VOLTAR", 55);
        
      textSize(45);
      text("IDEALIZAÇÃO DA ARTE, SONORIZAÇÃO E MECÂNICAS", width / 2 - textWidth("IDEALIZAÇÃO DA ARTE, SONORIZAÇÃO E MECÂNICAS") / 2, height / 2 + ((height / 2) / 8) * 0);
      text("PROGRAMAÇÃO", width / 2 - textWidth("PROGRAMAÇÃO") / 2, height / 2 + ((height / 2) / 8) * 3.75);
      
      textSize(30);
      text("BERNARDO MIGUEL GERÔNIMO DA CRUZ SILVA", width / 2 - textWidth("BERNARDO MIGUEL GERÔNIMO DA CRUZ SILVA") / 2, height / 2 + ((height / 2) / 8) * 0.75);
      text("LUCAS MARTIN MACEDO GAGLIANO", width / 2 - textWidth("LUCAS MARTIN MACEDO GAGLIANO") / 2, height / 2 + ((height / 2) / 8) * 4.5);
        
      textSize(20);
      text("RA: 21424187", width / 2 - textWidth("RA: 21424187") / 2, height / 2 + ((height / 2) / 8) * 1.25);
      text("RA: 21412302", width / 2 - textWidth("RA: 21412302") / 2, height / 2 + ((height / 2) / 8) * 5);
      break;
      
    case 4:
      textSize(196);
        
      numBotoes = 3;
      estaNoBotao = new boolean[numBotoes];
      titulosBotoes = new String[]{"1 JOGADOR", "2 JOGADORES"};
      text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
      UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
        
      for (int x = 0; x < numBotoes - 1; x++)
      {
        estaNoBotao[x] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75), titulosBotoes[x], 55);
        fill(255);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75) - textAscent() / 2 + 7.5, 15);
      }
      estaNoBotao[2] = UI.CriarBotoes(pa, 't', width / 13, height - (height / 16), "VOLTAR", 55);
      break;
        
    case 5:
      textSize(196);
      
      numBotoes = 4;
      estaNoBotao = new boolean[numBotoes];
      titulosBotoes = new String[]{"FÁCIL", "MÉDIO", "DIFÍCIL"};
      text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
      UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
          
      for (int x = 0; x < numBotoes - 1; x++)
      {
        estaNoBotao[x] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75), titulosBotoes[x], 55);  
        fill(255);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75) - textAscent() / 2 + 7.5, 15);
      }
      estaNoBotao[3] = UI.CriarBotoes(pa, 't', width / 13, height  - (height / 16), "VOLTAR", 55);
      break;
  }
}

private void NivelUm()
{
  int ladoMenu = 500;
  int numeroDivisoesRedeTotais = 20;
  int espacoDivisaoRede = 12;
  int alturaDivisaoRede = 36;
  int larguraDivisaoRede = 5; 
  
  for(int x = 0; x < numeroDivisoesRedeTotais * 48; x += 48)
    rect(width / 2 - larguraDivisaoRede / 2, x + espacoDivisaoRede, larguraDivisaoRede, alturaDivisaoRede);
    
  for (int x = 0; x < pontos.length; x++)
    text(pontos[x], width / 2 * x + width / 4 - textWidth(char(pontos[x])) / 2, height / 8);
  
  if (!estaComMenuAberto)
  {
    b.Colidir();
    b.AtualizarPosicao(); 
    b.Mover();
    
    for (int x = 0; x < j.length; x++)
      j[x].AtualizarPosicao(estaPressionandoTeclas[x][0], estaPressionandoTeclas[x][1]);
  }
  else
  {    
    textSize(125);
    b.Mover();
    
    fill(0);
    square(width / 2 - ladoMenu / 2, height / 2 - ladoMenu / 2, ladoMenu);
    fill(255);
    text("PAUSE", width / 2 - textWidth("PAUSE") / 2, height / 2 - ladoMenu / 2 + height / 4);
    
    numBotoes = 2;
    estaNoBotao = new boolean[numBotoes];
    titulosBotoes = new String[]{"VOLTAR AO JOGO", "MENU"};
    text("PAUSE", width / 2 - textWidth("PAUSE") / 2, height / 2 - ladoMenu / 2 + height / 4);
    UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
    
    for (int x = 0; x < numBotoes; x++)
    {
      estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75), titulosBotoes[x], 55);
      fill(255);
      square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75) - textAscent() / 2 + 7.5, 15);
    }
  }
      
  
  for (int x = 0; x < j.length; x++)
    j[x].Mover();
  
  for (int x = 0; x < pontos.length; x++)
    if (pontos[x] == 5)
      levelIndex = 7;
}

private void GameOver()
{
  textSize(55);
  
  numBotoes = 1;
  estaNoBotao = new boolean[numBotoes];
  titulosBotoes = new String[]{"MENU"};
  
  for (int x = 0; x < pontos.length; x++)
    if (pontos[x] == 5)
      text("PLAYER " + x + 1 + " WON!", width / 2 - textWidth("PLAYER " + x + " WON!") / 2, height / 4);
  
  for (int x = 0; x < numBotoes; x++)
  {
    estaNoBotao[x] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75), titulosBotoes[x], 55);
    fill(255);
    square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * (1 + x * 1.75) - textAscent() / 2, 15);
  }
}

private void AcoesBotoes(int indexBotao)
{
  switch(levelIndex)
  {
    case 1:
      switch(indexBotao)
      {
        case 0:
          levelIndex = 4;
          break;
        case 1:
          levelIndex = 2;
          break;
        case 2:
          levelIndex = 3;
          break;
        case 3:
          exit();
          break;
      }
      break;
    case 2:
      switch(indexBotao)
      {
        case 0:
          estaComAudio = !estaComAudio;
          break;
        case 1:
          estaComMicrofone = !estaComMicrofone;
          break;
        case 2:
          levelIndex = 1;
          break;
      }
      break;
    case 3:
      switch(indexBotao)
      {
        case 0:
          levelIndex = 1;
          break;
      }
      break;
    case 4:
      switch(indexBotao)
      {
        case 0:
          levelIndex = 5;
          estaMultiplayer = false;
          for (int x = 0; x < j.length; x++)
            j[x].tipoJogador = x % 2 == 0 ? "Player" : "AI";
          break;
        case 1:
          levelIndex = 6;
          estaMultiplayer = true;
          for (int x = 0; x < j.length; x++)
            j[x].tipoJogador = "Player";
          break;
        case 2:
          levelIndex = 1;
          break;
      }
      break;
    case 5:
      switch(indexBotao)
      {
        case 0: case 1: case 2:
          for (int x = 0; x < j.length; x++)
            if (j[x].tipoJogador == "AI")
              j[x].v = indexBotao == 0 ? 0.605 : indexBotao == 1 ? 0.85 : 1.15;
          levelIndex = 6;
          break;
        case 3:
          levelIndex = 4;
          break;
      }
      break;
    case 6:
      switch (indexBotao)
      {
        case 0:
          estaComMenuAberto = false;
          break;
          
        case 1:
          levelIndex = 1;
          b.Centralizar();
        
          for (int x = 0; x < pontos.length; x++)
            pontos[x] = 0;
          break;
      }
      break;
    case 7:
      switch (indexBotao)
      {
        case 0:
          levelIndex = 1;
          b.Centralizar();
        
          for (int x = 0; x < pontos.length; x++)
            pontos[x] = 0;
          break;
      }
      break;
  }
}
